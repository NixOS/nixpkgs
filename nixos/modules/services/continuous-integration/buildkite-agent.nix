{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.buildkite-agent;
  configFile = pkgs.writeText "buildkite-agent.cfg"
    ''
      token="${cfg.token}"
      name="${cfg.name}"
      meta-data="${cfg.meta-data}"
      hooks-path="${pkgs.buildkite-agent}/share/hooks"
      build-path="/var/lib/buildkite-agent/builds"
      bootstrap-script="${pkgs.buildkite-agent}/share/bootstrap.sh"
    '';
in

{
  options = {
    services.buildkite-agent = {
      enable = mkEnableOption "buildkite-agent";

      token = mkOption {
        type = types.str;
        description = ''
          The token from your Buildkite "Agents" page.
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
        { privateKey = mkOption {
            type = types.str;
            description = ''
              Private agent key.
            '';
          };
          publicKey = mkOption {
            type = types.str;
            description = ''
              Public agent key.
            '';
          };
        };
    };
  };

  config = mkIf config.services.buildkite-agent.enable {
    users.extraUsers.buildkite-agent =
      { name = "buildkite-agent";
        home = "/var/lib/buildkite-agent";
        createHome = true;
        description = "Buildkite agent user";
      };

    environment.systemPackages = [ pkgs.buildkite-agent ];

    systemd.services.buildkite-agent =
      { description = "Buildkite Agent";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment.HOME = "/var/lib/buildkite-agent";
        preStart = ''
            ${pkgs.coreutils}/bin/mkdir -m 0700 -p /var/lib/buildkite-agent/.ssh

            echo "${cfg.openssh.privateKey}" > /var/lib/buildkite-agent/.ssh/id_rsa
            ${pkgs.coreutils}/bin/chmod 600 /var/lib/buildkite-agent/.ssh/id_rsa

            echo "${cfg.openssh.publicKey}" > /var/lib/buildkite-agent/.ssh/id_rsa.pub
            ${pkgs.coreutils}/bin/chmod 600 /var/lib/buildkite-agent/.ssh/id_rsa.pub
          '';

        serviceConfig =
          { ExecStart = "${pkgs.buildkite-agent}/bin/buildkite-agent start --config ${configFile}";
            User = "buildkite-agent";
            RestartSec = 5;
            Restart = "on-failure";
            TimeoutSec = 10;
          };
      };
  };
}
