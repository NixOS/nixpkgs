{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.picom;

  libconfig = pkgs.formats.libconfig { };

in
{
  imports = [
    (mkAliasOptionModule [ "services" "compton" ] [ "services" "picom" ])

    # Removed options
    (mkRemovedOptionModule [ "services" "picom" "refreshRate" ] ''
      This option corresponds to `refresh-rate`, which has been unused
      since picom v6 and was subsequently removed by upstream.
      See https://github.com/yshui/picom/commit/bcbc410
    '')
    (mkRemovedOptionModule [ "services" "picom" "experimentalBackends" ] ''
      This option was removed by upstream since picom v10.
    '')

    # Refactored Options
    (mkRenamedOptionModule [ "services" "picom" "fade" ] [ "services" "picom" "settings" "fading" ])
    (mkRenamedOptionModule
      [ "services" "picom" "fadeDelta" ]
      [ "services" "picom" "settings" "fade-delta" ]
    )
    (mkRenamedOptionModule
      [ "services" "picom" "fadeExclude" ]
      [ "services" "picom" "settings" "fade-exclude" ]
    )
    (mkRenamedOptionModule [ "services" "picom" "shadow" ] [ "services" "picom" "settings" "shadow" ])
    (mkRenamedOptionModule
      [ "services" "picom" "shadowOpacity" ]
      [ "services" "picom" "settings" "shadow-opacity" ]
    )
    (mkRenamedOptionModule
      [ "services" "picom" "shadowExclude" ]
      [ "services" "picom" "settings" "shadow-exclude" ]
    )
    (mkRenamedOptionModule
      [ "services" "picom" "activeOpacity" ]
      [ "services" "picom" "settings" "active-opacity" ]
    )
    (mkRenamedOptionModule
      [ "services" "picom" "inactiveOpacity" ]
      [ "services" "picom" "settings" "inactive-opacity" ]
    )
    (mkRenamedOptionModule
      [ "services" "picom" "wintypes" ]
      [ "services" "picom" "settings" "wintypes" ]
    )
    (mkRenamedOptionModule
      [ "services" "picom" "opacityRules" ]
      [ "services" "picom" "settings" "opacity-rule" ]
    )
    (mkRenamedOptionModule [ "services" "picom" "backend" ] [ "services" "picom" "settings" "backend" ])
    (mkRenamedOptionModule [ "services" "picom" "vSync" ] [ "services" "picom" "settings" "vsync" ])
    (mkRenamedOptionModule
      [ "services" "picom" "menuOpacity" ]
      [ "services" "picom" "settings" "wintypes" "menu" "opacity" ]
    )

    # List/Array Migrations
    (mkRenamedOptionModule
      [ "services" "picom" "fadeSteps" "0" ]
      [ "services" "picom" "settings" "fade-in-step" ]
    )
    (mkRenamedOptionModule
      [ "services" "picom" "fadeSteps" "1" ]
      [ "services" "picom" "settings" "fade-out-step" ]
    )
    (mkRenamedOptionModule
      [ "services" "picom" "shadowOffsets" "0" ]
      [ "services" "picom" "settings" "shadow-offset-x" ]
    )
    (mkRenamedOptionModule
      [ "services" "picom" "shadowOffsets" "1" ]
      [ "services" "picom" "settings" "shadow-offset-y" ]
    )
  ];

  options.services.picom = {
    enable = mkEnableOption "Picom as the X.org composite manager";

    package = mkPackageOption pkgs "picom" { };

    settings = mkOption {
      description = ''
        Define picom configuration options here, a configuration file will be generated for use by picom.
      '';
      type = libconfig.type;
      default = {
        backend = "xrender";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.picom = {
      description = "Picom composite manager";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${getExe cfg.package} --config ${libconfig.generate "picom.conf" cfg.settings}";
        RestartSec = 3;
        Restart = "always";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
