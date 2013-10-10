# Global configuration for wvdial.

{ config, pkgs, ... }:

with pkgs.lib;

let

  configFile = ''
    [Dialer Defaults]
    PPPD PATH = ${pkgs.ppp}/sbin/pppd
    ${config.environment.wvdial.dialerDefaults}
  '';

  cfg = config.environment.wvdial;

in
{
  ###### interface

  options = {

    environment.wvdial = {

      dialerDefaults = mkOption {
        default = "";
        type = types.string;
        example = ''Init1 = AT+CGDCONT=1,"IP","internet.t-mobile"'';
        description = ''
          Contents of the "Dialer Defaults" section of
          <filename>/etc/wvdial.conf</filename>.
        '';
      };

      pppDefaults = mkOption {
        default = ''
          noipdefault
          usepeerdns
          defaultroute
          persist
          noauth
        '';
        type = types.string;
        description = "Default ppp settings for wvdial.";
      };

    };

  };

  ###### implementation

  config = mkIf (cfg.dialerDefaults != "") {

    environment = {

      etc =
      [
        { source = pkgs.writeText "wvdial.conf" configFile;
          target = "wvdial.conf";
        }
        { source = pkgs.writeText "wvdial" cfg.pppDefaults;
          target = "ppp/peers/wvdial";
        }
      ];

    };

  };

}
