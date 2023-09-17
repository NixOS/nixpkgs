{ config, pkgs, lib, ... }:
{
  options.services.microbin = with lib; {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Microbin service";
    };
    user = lib.mkOption {
      type = types.str;
      default = "microbin";
      description = "The user for Microbin service";
    };
    group = lib.mkOption {
      type = types.str;
      default = "microbin";
      description = "The group for Microbin service";
    };
    dataDir = lib.mkOption {
      type = types.str;
      default = "/var/lib/microbin";
      description = "The directory where Microbin data is stored";
    };
    cli-args = mkOption {
      type = types.str;
      description = "See https://microbin.eu/documentation/";
      example = ''
        --port 8080 --highlightsyntax --gc-days 100 --qr --no-listing --wide --no-eternal-pasta
      '';
    };
  };

  config = let
    cfg = config.services.microbin;
  in lib.mkIf (cfg.enable) {

    systemd.services.microbin = {
      description = "Microbin Service";
      after = [ "network.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${pkgs.microbin}/bin/microbin ${cfg.cli-args}";
      };
      wantedBy = [ "multi-user.target" ];
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      description = "Microbin User";
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      homeMode = "770";
    };
    users.groups.${cfg.group} = {};
  };

  meta = {
    maintainers = with lib.maintainers; [ luochen1990 ];
  };
}
