{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.modemmanager;
in
{
  meta = {
    maintainers = lib.teams.freedesktop.members;
  };

  options = with lib; {
    networking.modemmanager = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use ModemManager to manage modem devices.
          This is usually used by some higher layer manager such as NetworkManager
          but can be used standalone especially if using a modem for non-IP
          connectivity (e.g. GPS).
        '';
      };

      package = mkPackageOption pkgs "modemmanager" { };

      fccUnlockScripts = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              id = mkOption {
                type = types.str;
                description = "vid:pid of either the PCI or USB vendor and product ID";
              };
              path = mkOption {
                type = types.path;
                description = "Path to the unlock script";
              };
            };
          }
        );
        default = [ ];
        example = literalExpression ''[{ id = "03f0:4e1d"; path = "''${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/03f0:4e1d"; }]'';
        description = ''
          List of FCC unlock scripts to enable on the system, behaving as described in
          https://modemmanager.org/docs/modemmanager/fcc-unlock/#integration-with-third-party-fcc-unlock-tools.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc = builtins.listToAttrs (
      map (
        e:
        lib.nameValuePair "ModemManager/fcc-unlock.d/${e.id}" {
          source = e.path;
        }
      ) cfg.fccUnlockScripts
    );

    systemd.services.ModemManager = {
      aliases = [ "dbus-org.freedesktop.ModemManager1.service" ];
      path = lib.optionals (cfg.fccUnlockScripts != [ ]) [
        pkgs.libqmi
        pkgs.libmbim
      ];
    };

    /*
      [modem-manager]
      Identity=unix-group:networkmanager
      Action=org.freedesktop.ModemManager*
      ResultAny=yes
      ResultInactive=no
      ResultActive=yes
    */
    security.polkit.enable = true;
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("networkmanager")
          && action.id.indexOf("org.freedesktop.ModemManager") == 0
          )
            { return polkit.Result.YES; }
      });
    '';

    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };
}
