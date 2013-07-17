{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.services.apcupsd;
    configFile = pkgs.writeText "apcupsd.conf" ''
      ## apcupsd.conf v1.1 ##
      # apcupsd complains if the first line is not like above.
      ${cfg.configText}
    '';
in

{

  ###### interface

  options = {

    services.apcupsd = {

      enable = mkOption {
        default = false;
        type = types.uniq types.bool;
        description = ''
          Whether to enable the APC UPS daemon. apcupsd monitors your UPS and
          permits orderly shutdown of your computer in the event of a power
          failure. User manual: http://www.apcupsd.com/manual/manual.html.
          Note that apcupsd runs as root (to allow shutdown of computer).
          You can check the status of your UPS with the "apcaccess" command.
        '';
      };

      configText = mkOption {
        default = ''
          UPSTYPE usb
          NISIP 127.0.0.1
          BATTERYLEVEL 50
          MINUTES 5
        '';
        type = types.string;
        description = ''
          Contents of the runtime configuration file, apcupsd.conf. The default
          settings makes apcupsd autodetect USB UPSes, limit network access to
          localhost and shutdown the system when the battery level is below 50
          percent, or when the UPS has calculated that it has 5 minutes or less
          of remaining power-on time. See man apcupsd.conf for details.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    # Give users access to the "apcaccess" tool
    environment.systemPackages = [ pkgs.apcupsd ];

    # NOTE 1: apcupsd runs as root because it needs permission to run
    # "shutdown"
    #
    # NOTE 2: When apcupsd calls "wall", it prints an error because stdout is
    # not connected to a tty (it is connected to the journal):
    #   wall: cannot get tty name: Inappropriate ioctl for device
    # The message still gets through.
    #
    # TODO: apcupsd calls "mail" on powerfail etc. events, how should we
    # handle that? A configurable mail package or let the event logic be
    # configured from nix expressions?
    systemd.services.apcupsd = {
      description = "UPS daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.apcupsd}/bin/apcupsd -b -f ${configFile} -d1";
      };
    };

  };

}
