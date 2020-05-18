{pkgs, config, lib, ...}:

with lib;

let
  cfg = config.services.hologram-agent;

  cfgFile = pkgs.writeText "hologram-agent.json" (builtins.toJSON {
    host = cfg.dialAddress;
  });
in {
  options = {
    services.hologram-agent = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Hologram agent for AWS instance credentials";
      };

      dialAddress = mkOption {
        type        = types.str;
        default     = "localhost:3100";
        description = "Hologram server and port.";
      };

      httpPort = mkOption {
        type        = types.str;
        default     = "80";
        description = "Port for metadata service to listen on.";
      };

    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "dummy" ];

    networking.interfaces.dummy0.ipv4.addresses = [
      { address = "169.254.169.254"; prefixLength = 32; }
    ];

    systemd.services.hologram-agent = {
      description = "Provide EC2 instance credentials to machines outside of EC2";
      after       = [ "network.target" ];
      wantedBy    = [ "multi-user.target" ];
      requires    = [ "network-link-dummy0.service" "network-addresses-dummy0.service" ]; 
      preStart = ''
        /run/current-system/sw/bin/rm -fv /run/hologram.sock
      '';
      serviceConfig = {
        ExecStart = "${pkgs.hologram.bin}/bin/hologram-agent -debug -conf ${cfgFile} -port ${cfg.httpPort}";
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ nand0p ];
}
