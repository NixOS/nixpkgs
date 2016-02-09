{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.mathics;

in {
  options = {
    services.mathics = {
      enable = mkEnableOption "Mathics notebook service";

      external = mkOption {
        type = types.bool;
        default = false;
        description = "Listen on all interfaces, rather than just localhost?";
      };

      port = mkOption {
        type = types.int;
        default = 8000;
        description = "TCP port to listen on.";
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraUsers.mathics = {
      group = config.users.extraGroups.mathics.name;
      description = "Mathics user";
      home = "/var/lib/mathics";
      createHome = true;
      uid = config.ids.uids.mathics;
    };

    users.extraGroups.mathics.gid = config.ids.gids.mathics;

    systemd.services.mathics = {
      description = "Mathics notebook server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = config.users.extraUsers.mathics.name;
        Group = config.users.extraGroups.mathics.name;
        ExecStart = concatStringsSep " " [
          "${pkgs.mathics}/bin/mathicsserver"
          "--port" (toString cfg.port)
          (if cfg.external then "--external" else "")
        ];
      };
    };
  };
}
