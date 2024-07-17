{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.netatalk;
  settingsFormat = pkgs.formats.ini { };
  afpConfFile = settingsFormat.generate "afp.conf" cfg.settings;
in
{
  options = {
    services.netatalk = {

      enable = mkEnableOption "the Netatalk AFP fileserver";

      port = mkOption {
        type = types.port;
        default = 548;
        description = "TCP port to be used for AFP.";
      };

      settings = mkOption {
        inherit (settingsFormat) type;
        default = { };
        example = {
          Global = {
            "uam list" = "uams_guest.so";
          };
          Homes = {
            path = "afp-data";
            "basedir regex" = "/home";
          };
          example-volume = {
            path = "/srv/volume";
            "read only" = true;
          };
        };
        description = ''
          Configuration for Netatalk. See
          {manpage}`afp.conf(5)`.
        '';
      };

      extmap = mkOption {
        type = types.lines;
        default = "";
        description = ''
          File name extension mappings.
          See {manpage}`extmap.conf(5)`. for more information.
        '';
      };

    };
  };

  imports = (
    map
      (
        option:
        mkRemovedOptionModule [
          "services"
          "netatalk"
          option
        ] "This option was removed in favor of `services.netatalk.settings`."
      )
      [
        "extraConfig"
        "homes"
        "volumes"
      ]
  );

  config = mkIf cfg.enable {

    services.netatalk.settings.Global = {
      "afp port" = toString cfg.port;
      "extmap file" = "${pkgs.writeText "extmap.conf" cfg.extmap}";
    };

    systemd.services.netatalk = {
      description = "Netatalk AFP fileserver for Macintosh clients";
      unitConfig.Documentation = "man:afp.conf(5) man:netatalk(8) man:afpd(8) man:cnid_metad(8) man:cnid_dbd(8)";
      after = [
        "network.target"
        "avahi-daemon.service"
      ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.netatalk ];

      serviceConfig = {
        Type = "forking";
        GuessMainPID = "no";
        PIDFile = "/run/lock/netatalk";
        ExecStart = "${pkgs.netatalk}/sbin/netatalk -F ${afpConfFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP  $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -TERM $MAINPID";
        Restart = "always";
        RestartSec = 1;
        StateDirectory = [ "netatalk/CNID" ];
      };

    };

    security.pam.services.netatalk.unixAuth = true;

  };

}
