{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.buildkite-agents;

  hooksDir =
    hooks:
    let
      mkHookEntry = name: text: ''
        ln --symbolic ${pkgs.writeShellApplication { inherit name text; }}/bin/${name} $out/${name}
      '';
    in
    pkgs.runCommand "buildkite-agent-hooks"
      {
        preferLocalBuild = true;
      }
      ''
        mkdir $out
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList mkHookEntry hooks)}
      '';

  buildkiteOptions =
    {
      name ? "",
      config,
      ...
    }:
    {
      options = {
        enable = lib.mkOption {
          default = true;
          type = lib.types.bool;
          description = "Whether to enable this buildkite agent";
        };

        package = lib.mkPackageOption pkgs "buildkite-agent" { };

        dataDir = lib.mkOption {
          default = "/var/lib/buildkite-agent-${name}";
          description = "The workdir for the agent";
          type = lib.types.str;
        };

        extraGroups = lib.mkOption {
          default = [ "keys" ];
          description = "Groups the user for this buildkite agent should belong to";
          type = lib.types.listOf lib.types.str;
        };

        runtimePackages = lib.mkOption {
          default = [
            pkgs.bash
            pkgs.gnutar
            pkgs.gzip
            pkgs.git
            pkgs.nix
          ];
          defaultText = lib.literalExpression "[ pkgs.bash pkgs.gnutar pkgs.gzip pkgs.git pkgs.nix ]";
          description = "Add programs to the buildkite-agent environment";
          type = lib.types.listOf lib.types.package;
        };

        tokenPath = lib.mkOption {
          type = lib.types.path;
          description = ''
            The token from your Buildkite "Agents" page.

            A run-time path to the token file, which is supposed to be provisioned
            outside of Nix store.
          '';
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "%hostname-${name}-%n";
          description = ''
            The name of the agent as seen in the buildkite dashboard.
          '';
        };

        tags = lib.mkOption {
          type = lib.types.attrsOf (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
          default = { };
          example = {
            queue = "default";
            docker = "true";
            ruby2 = "true";
          };
          description = ''
            Tags for the agent.
          '';
        };

        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
          example = "debug=true";
          description = ''
            Extra lines to be added verbatim to the configuration file.
          '';
        };

        privateSshKeyPath = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          ## maximum care is taken so that secrets (ssh keys and the CI token)
          ## don't end up in the Nix store.
          apply = final: if final == null then null else toString final;

          description = ''
            OpenSSH private key

            A run-time path to the key file, which is supposed to be provisioned
            outside of Nix store.
          '';
        };

        hooks = lib.mkOption {
          type = lib.types.attrsOf lib.types.lines;
          default = { };
          example = lib.literalExpression ''
            {
              environment = '''
                export SECRET_VAR=`head -1 /run/keys/secret`
              ''';
            }'';
          description = ''
            "Agent" hooks to install.
            See <https://buildkite.com/docs/agent/v3/hooks> for possible options.
          '';
        };

        hooksPath = lib.mkOption {
          type = lib.types.path;
          default = hooksDir config.hooks;
          defaultText = lib.literalMD "generated from {option}`services.buildkite-agents.<name>.hooks`";
          description = ''
            Path to the directory storing the hooks.
            Consider using {option}`services.buildkite-agents.<name>.hooks.<name>`
            instead.
          '';
        };

        shell = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.bash}/bin/bash -e -c";
          defaultText = lib.literalExpression ''"''${pkgs.bash}/bin/bash -e -c"'';
          description = ''
            Command that buildkite-agent 3 will execute when it spawns a shell.
          '';
        };
      };
    };
  enabledAgents = lib.filterAttrs (n: v: v.enable) cfg;
  mapAgents = function: lib.mkMerge (lib.mapAttrsToList function enabledAgents);
in
{
  options.services.buildkite-agents = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule buildkiteOptions);
    default = { };
    description = ''
      Attribute set of buildkite agents.
      The attribute key is combined with the hostname and a unique integer to
      create the final agent name. This can be overridden by setting the `name`
      attribute.
    '';
  };

  config.users.users = mapAgents (
    name: cfg: {
      "buildkite-agent-${name}" = {
        name = "buildkite-agent-${name}";
        home = cfg.dataDir;
        createHome = true;
        description = "Buildkite agent user";
        extraGroups = cfg.extraGroups;
        isSystemUser = true;
        group = "buildkite-agent-${name}";
      };
    }
  );
  config.users.groups = mapAgents (
    name: cfg: {
      "buildkite-agent-${name}" = { };
    }
  );

  config.systemd.services = mapAgents (
    name: cfg: {
      "buildkite-agent-${name}" = {
        description = "Buildkite Agent";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = cfg.runtimePackages ++ [
          cfg.package
          pkgs.coreutils
        ];
        environment = config.networking.proxy.envVars // {
          HOME = cfg.dataDir;
          NIX_REMOTE = "daemon";
        };

        ## NB: maximum care is taken so that secrets (ssh keys and the CI token)
        ##     don't end up in the Nix store.
        preStart =
          let
            sshDir = "${cfg.dataDir}/.ssh";
            tagStr =
              name: value:
              if lib.isList value then
                lib.concatStringsSep "," (builtins.map (v: "${name}=${v}") value)
              else
                "${name}=${value}";
            tagsStr = lib.concatStringsSep "," (lib.mapAttrsToList tagStr cfg.tags);
          in
          lib.optionalString (cfg.privateSshKeyPath != null) ''
            mkdir -m 0700 -p "${sshDir}"
            install -m600 "${toString cfg.privateSshKeyPath}" "${sshDir}/id_rsa"
          ''
          + ''
            cat > "${cfg.dataDir}/buildkite-agent.cfg" <<EOF
            token="$(cat ${toString cfg.tokenPath})"
            name="${cfg.name}"
            shell="${cfg.shell}"
            tags="${tagsStr}"
            build-path="${cfg.dataDir}/builds"
            hooks-path="${cfg.hooksPath}"
            ${cfg.extraConfig}
            EOF
          '';

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/buildkite-agent start --config ${cfg.dataDir}/buildkite-agent.cfg";
          User = "buildkite-agent-${name}";
          RestartSec = 5;
          Restart = "on-failure";
          TimeoutSec = 10;
          # set a long timeout to give buildkite-agent a chance to finish current builds
          TimeoutStopSec = "2 min";
          KillMode = "mixed";
        };
      };
    }
  );

  config.assertions = mapAgents (
    name: cfg: [
      {
        assertion = cfg.hooksPath != hooksDir cfg.hooks -> cfg.hooks == { };
        message = ''
          Options `services.buildkite-agents.${name}.hooksPath' and
          `services.buildkite-agents.${name}.hooks.<name>' are mutually exclusive.
        '';
      }
    ]
  );
}
