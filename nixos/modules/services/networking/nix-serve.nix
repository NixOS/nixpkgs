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

      secretKeyFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The path to the file used for signing derivation data.
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

      path = [ config.nix.package.out pkgs.bzip2.bin ];
      environment.NIX_REMOTE = "daemon";
      environment.NIX_SECRET_KEY_FILE = cfg.secretKeyFile;

      serviceConfig = {
        ExecStart = "${pkgs.nix-serve}/bin/nix-serve " +
          "--listen ${cfg.bindAddress}:${toString cfg.port} ${cfg.extraParams}";
        User = "nix-serve";
        Group = "nogroup";
      };
    };

    users.extraUsers.nix-serve = {
      description = "Nix-serve user";
      uid = config.ids.uids.nix-serve;
    };
  };
}
