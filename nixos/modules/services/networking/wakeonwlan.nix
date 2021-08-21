{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wakeonwlan;

  mkWowlanService = name: cfg:
    nameValuePair "wowlan-${name}" {
      description = "Enable WoWLAN for interface ${name}";
      requires = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        ${pkgs.iw}/bin/iw phy ${name} wowlan enable ${concatStringsSep " " cfg.methods}
      '';
    };
in
{
  options.services.wakeonwlan.interfaces = mkOption {
    default = { };
    description = ''
      Wireless interfaces where you want to enable WoWLAN. You can list
      available interfaces with <code>iw dev</code>.
    '';
    example = literalExample ''
      {
        phy0.methods = [
          "magic-packet"
          "disconnect"
          "gtk-rekey-failure"
          "eap-identity-request"
          "rfkill-release"
        ];
        phy2.methods = [ "any" ];
      }
    '';
    type = types.attrsOf (
      types.submodule {
        options = {
          methods = mkOption {
            type = types.listOf (types.enum [
              "4way-handshake"
              "any"
              "disconnect"
              "eap-identity-request"
              "gtk-rekey-failure"
              "magic-packet"
              "rfkill-release"
            ]);
            description = "Wake-On-WiFiLan methods for this interface.";
          };
        };
      }
    );
  };

  config = mkIf (cfg.interfaces != {}) {
    systemd.services = mapAttrs' mkWowlanService cfg.interfaces;
  };
}

