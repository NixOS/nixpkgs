{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.buildkite-agent;
  configFile = pkgs.writeText "buildkite-agent.cfg"
    ''
      token="${cfg.token}"
      name="${cfg.name}"
      meta-data="${cfg.meta-data}"
      hooks-path="${cfg.package}/share/hooks"
      build-path="${cfg.dataDir}"
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
        default = [ pkgs.nix ];
        defaultText = "[ pkgs.nix ]";
        description = "Add programs to the buildkite-agent environment";
        type = types.listOf types.package;
      };

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
        home = cfg.dataDir;
        createHome = true;
        description = "Buildkite agent user";
      };

    environment.systemPackages = [ cfg.package ];

    systemd.services.buildkite-agent =
      { description = "Buildkite Agent";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = cfg.runtimePackages;
        environment = config.networking.proxy.envVars // {
          HOME = cfg.dataDir;
          NIX_REMOTE = "daemon";
        };
        preStart = ''
          ${pkgs.coreutils}/bin/mkdir -m 0700 -p ${cfg.dataDir}/.ssh

          echo "${cfg.openssh.privateKey}" > ${cfg.dataDir}/.ssh/id_rsa
          ${pkgs.coreutils}/bin/chmod 600 ${cfg.dataDir}/.ssh/id_rsa

          echo "${cfg.openssh.publicKey}" > ${cfg.dataDir}/.ssh/id_rsa.pub
          ${pkgs.coreutils}/bin/chmod 600 ${cfg.dataDir}/.ssh/id_rsa.pub
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
