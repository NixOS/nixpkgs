{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nix-serve;
in
{
  options = {
    services.nix-serve = {
      enable = mkEnableOption "nix-serve, the standalone Nix binary cache server";

      port = mkOption {
        type = types.int;
        default = 5000;
        description = ''
          Port number where nix-serve will listen on.
        '';
      };

      bindAddress = mkOption {
        type = types.string;
        default = "0.0.0.0";
        description = ''
          IP address where nix-serve will bind its listening socket.
        '';
      };

      extraParams = mkOption {
        type = types.string;
        default = "";
        description = ''
          Extra command line parameters for nix-serve.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nix-serve = {
      description = "nix-serve binary cache server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ config.nix.package pkgs.bzip2 ];
      environment.NIX_REMOTE = "daemon";

      serviceConfig = {
        ExecStart = "${pkgs.nix-serve}/bin/nix-serve " +
          "--port ${cfg.bindAddress}:${toString cfg.port} ${cfg.extraParams}";
        User = "nobody";
        Group = "nogroup";
      };
    };
  };
}
