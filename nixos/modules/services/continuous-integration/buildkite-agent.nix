{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.buildkite-agent;
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
        description = ''
          The name of the agent.
        '';
      };

      meta-data = mkOption {
        type = types.str;
        default = "";
        description = ''
          Meta data for the agent.
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
    };
  };

  config = mkIf config.services.buildkite-agent.enable {
    users.extraUsers.buildkite-agent =
      { name = "buildkite-agent";
        home = cfg.dataDir;
        createHome = true;
        description = "Buildkite agent user";
        extraGroups = [ "keys" ];
      };

    environment.systemPackages = [ cfg.package ];

    systemd.services.buildkite-agent =
      let copy = x: target: perms:
                 "cp -f ${x} ${target}; ${pkgs.coreutils}/bin/chmod ${toString perms} ${target}; ";
      in
      { description = "Buildkite Agent";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = cfg.runtimePackages;
        environment = config.networking.proxy.envVars // {
          HOME = cfg.dataDir;
          NIX_REMOTE = "daemon";
        };

        ## NB: maximum care is taken so that secrets (ssh keys and the CI token)
        ##     don't end up in the Nix store.
        preStart = ''
            ${pkgs.coreutils}/bin/mkdir -m 0700 -p ${cfg.dataDir}/.ssh
            ${copy (toString cfg.openssh.privateKeyPath) "${cfg.dataDir}/.ssh/id_rsa"     600}
            ${copy (toString cfg.openssh.publicKeyPath)  "${cfg.dataDir}/.ssh/id_rsa.pub" 600}

            cat > "${cfg.dataDir}/buildkite-agent.cfg" <<EOF
            token="$(cat ${toString cfg.tokenPath})"
            name="${cfg.name}"
            meta-data="${cfg.meta-data}"
            hooks-path="${pkgs.buildkite-agent}/share/hooks"
            build-path="${cfg.dataDir}/builds"
            bootstrap-script="${pkgs.buildkite-agent}/share/bootstrap.sh"
            EOF
          '';

        serviceConfig =
          { ExecStart = "${pkgs.buildkite-agent}/bin/buildkite-agent start --config /var/lib/buildkite-agent/buildkite-agent.cfg";
            User = "buildkite-agent";
            RestartSec = 5;
            Restart = "on-failure";
            TimeoutSec = 10;
          };
      };
  };
  imports = [
    (mkRenamedOptionModule [ "services" "buildkite-agent" "token" ]                [ "services" "buildkite-agent" "tokenPath" ])
    (mkRenamedOptionModule [ "services" "buildkite-agent" "openssh" "privateKey" ] [ "services" "buildkite-agent" "openssh" "privateKeyPath" ])
    (mkRenamedOptionModule [ "services" "buildkite-agent" "openssh" "publicKey" ]  [ "services" "buildkite-agent" "openssh" "publicKeyPath" ])
  ];
}
