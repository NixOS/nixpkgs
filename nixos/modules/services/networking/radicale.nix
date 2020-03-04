{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.radicale;

  confFile = pkgs.writeText "radicale.conf" cfg.config;

  # This enables us to default to version 2 while still not breaking configurations of people with version 1
  defaultPackage = if versionAtLeast config.system.stateVersion "17.09" then {
    pkg = pkgs.radicale2;
    text = "pkgs.radicale2";
  } else {
    pkg = pkgs.radicale1;
    text = "pkgs.radicale1";
  };
in

{

  options = {
    services.radicale.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Enable Radicale CalDAV and CardDAV server.
      '';
    };

    services.radicale.package = mkOption {
      type = types.package;
      default = defaultPackage.pkg;
      defaultText = defaultPackage.text;
      description = ''
        Radicale package to use. This defaults to version 1.x if
        <literal>system.stateVersion &lt; 17.09</literal> and version 2.x
        otherwise.
      '';
    };

    services.radicale.config = mkOption {
      type = types.str;
      default = "";
      description = ''
        Radicale configuration, this will set the service
        configuration file.
      '';
    };

    services.radicale.extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra arguments passed to the Radicale daemon.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users.radicale =
      { uid = config.ids.uids.radicale;
        description = "radicale user";
        home = "/var/lib/radicale";
        createHome = true;
      };

    users.groups.radicale =
      { gid = config.ids.gids.radicale; };

    systemd.services.radicale = {
      description = "A Simple Calendar and Contact Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = concatStringsSep " " ([
          "${cfg.package}/bin/radicale" "-C" confFile
        ] ++ (
          map escapeShellArg cfg.extraArgs
        ));
        User = "radicale";
        Group = "radicale";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ aneeshusa infinisil ];
}
