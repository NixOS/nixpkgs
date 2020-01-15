{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.buildkite-agent;

  mkHookOption = { name, description, example ? null }: {
    inherit name;
    value = mkOption {
      default = null;
      inherit description;
      type = types.nullOr types.lines;
    } // (if example == null then {} else { inherit example; });
  };
  mkHookOptions = hooks: listToAttrs (map mkHookOption hooks);

  hooksDir = let
    mkHookEntry = name: value: ''
      cat > $out/${name} <<'EOF'
      #! ${pkgs.runtimeShell}
      set -e
      ${value}
      EOF
      chmod 755 $out/${name}
    '';
  in pkgs.runCommand "buildkite-agent-hooks" { preferLocalBuild = true; } ''
    mkdir $out
    ${concatStringsSep "\n" (mapAttrsToList mkHookEntry (filterAttrs (n: v: v != null) cfg.hooks))}
  '';

in

{
  options = {
    services.buildkite-agent = {
      enable = mkEnableOption "buildkite-agent";

      package = mkOption {
        default = pkgs.buildkite-agent;
        defaultText = "pkgs.buildkite-agent";
        description = "Which buildkite-agent derivation to use";
        type = types.package;
      };

      dataDir = mkOption {
        default = "/var/lib/buildkite-agent";
        description = "The workdir for the agent";
        type = types.str;
      };

      runtimePackages = mkOption {
        default = [ pkgs.bash pkgs.nix ];
        defaultText = "[ pkgs.bash pkgs.nix ]";
        description = "Add programs to the buildkite-agent environment";
        type = types.listOf types.package;
      };

      tokenPath = mkOption {
        type = types.path;
        description = ''
          The token from your Buildkite "Agents" page.

          A run-time path to the token file, which is supposed to be provisioned
          outside of Nix store.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "%hostname-%n";
        description = ''
          The name of the agent.
        '';
      };

      meta-data = mkOption {
        type = types.str;
        default = "";
        example = "queue=default,docker=true,ruby2=true";
        description = ''
          Meta data for the agent. This is a comma-separated list of
          <code>key=value</code> pairs.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = "debug=true";
        description = ''
          Extra lines to be added verbatim to the configuration file.
        '';
      };

      openssh =
        { privateKeyPath = mkOption {
            type = types.path;
            description = ''
              Private agent key.

              A run-time path to the key file, which is supposed to be provisioned
              outside of Nix store.
            '';
          };
          publicKeyPath = mkOption {
            type = types.path;
            description = ''
              Public agent key.

              A run-time path to the key file, which is supposed to be provisioned
              outside of Nix store.
            '';
          };
        };

      hooks = mkHookOptions [
        { name = "checkout";
          description = ''
            The `checkout` hook script will replace the default checkout routine of the
            bootstrap.sh script. You can use this hook to do your own SCM checkout
            behaviour
          ''; }
        { name = "command";
          description = ''
            The `command` hook script will replace the default implementation of running
            the build command.
          ''; }
        { name = "environment";
          description = ''
            The `environment` hook will run before all other commands, and can be used
            to set up secrets, data, etc. Anything exported in hooks will be available
            to the build script.

            Note: the contents of this file will be copied to the world-readable
            Nix store.
          '';
          example = ''
            export SECRET_VAR=`head -1 /run/keys/secret`
          ''; }
        { name = "post-artifact";
          description = ''
            The `post-artifact` hook will run just after artifacts are uploaded
          ''; }
        { name = "post-checkout";
          description = ''
            The `post-checkout` hook will run after the bootstrap script has checked out
            your projects source code.
          ''; }
        { name = "post-command";
          description = ''
            The `post-command` hook will run after the bootstrap script has run your
            build commands
          ''; }
        { name = "pre-artifact";
          description = ''
            The `pre-artifact` hook will run just before artifacts are uploaded
          ''; }
        { name = "pre-checkout";
          description = ''
            The `pre-checkout` hook will run just before your projects source code is
            checked out from your SCM provider
          ''; }
        { name = "pre-command";
          description = ''
            The `pre-command` hook will run just before your build command runs
          ''; }
        { name = "pre-exit";
          description = ''
            The `pre-exit` hook will run just before your build job finishes
          ''; }
      ];

      hooksPath = mkOption {
        type = types.path;
        default = hooksDir;
        defaultText = "generated from services.buildkite-agent.hooks";
        description = ''
          Path to the directory storing the hooks.
          Consider using <option>services.buildkite-agent.hooks.&lt;name&gt;</option>
          instead.
        '';
      };
    };
  };

  config = mkIf config.services.buildkite-agent.enable {
    users.users.buildkite-agent =
      { name = "buildkite-agent";
        home = cfg.dataDir;
        createHome = true;
        description = "Buildkite agent user";
        extraGroups = [ "keys" ];
        isSystemUser = true;
      };

    environment.systemPackages = [ cfg.package ];

    systemd.services.buildkite-agent =
      { description = "Buildkite Agent";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = cfg.runtimePackages ++ [ pkgs.coreutils ];
        environment = config.networking.proxy.envVars // {
          HOME = cfg.dataDir;
          NIX_REMOTE = "daemon";
        };

        ## NB: maximum care is taken so that secrets (ssh keys and the CI token)
        ##     don't end up in the Nix store.
        preStart = let
          sshDir = "${cfg.dataDir}/.ssh";
          metaData = if cfg.meta-data == ""
            then ""
            else "meta-data=${cfg.meta-data}";
        in
          ''
            mkdir -m 0700 -p "${sshDir}"
            cp -f "${toString cfg.openssh.privateKeyPath}" "${sshDir}/id_rsa"
            cp -f "${toString cfg.openssh.publicKeyPath}"  "${sshDir}/id_rsa.pub"
            chmod 600 "${sshDir}"/id_rsa*

            cat > "${cfg.dataDir}/buildkite-agent.cfg" <<EOF
            token="$(cat ${toString cfg.tokenPath})"
            name="${cfg.name}"
            ${metaData}
            build-path="${cfg.dataDir}/builds"
            hooks-path="${cfg.hooksPath}"
            ${cfg.extraConfig}
            EOF
          '';

        serviceConfig =
          { ExecStart = "${cfg.buildkite-agent}/bin/buildkite-agent start --config /var/lib/buildkite-agent/buildkite-agent.cfg";
            User = "buildkite-agent";
            RestartSec = 5;
            Restart = "on-failure";
            TimeoutSec = 10;
          };
      };

    assertions = [
      { assertion = cfg.hooksPath == hooksDir || all (v: v == null) (attrValues cfg.hooks);
        message = ''
          Options `services.buildkite-agent.hooksPath' and
          `services.buildkite-agent.hooks.<name>' are mutually exclusive.
        '';
      }
    ];
  };
  imports = [
    (mkRenamedOptionModule [ "services" "buildkite-agent" "token" ]                [ "services" "buildkite-agent" "tokenPath" ])
    (mkRenamedOptionModule [ "services" "buildkite-agent" "openssh" "privateKey" ] [ "services" "buildkite-agent" "openssh" "privateKeyPath" ])
    (mkRenamedOptionModule [ "services" "buildkite-agent" "openssh" "publicKey" ]  [ "services" "buildkite-agent" "openssh" "publicKeyPath" ])
  ];
}
