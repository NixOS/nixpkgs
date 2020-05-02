{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  uid = config.ids.uids.upmpdcli;
  gid = config.ids.gids.upmpdcli;
  cfg = config.services.upmpdcli;

  defaultConf = {
    # upnp network parameters
    ##upnpiface =
    upnpip = "127.0.0.1";
    upnpport = 49152; # libupnp/pupnp defaults to using the first free port after 49152. Note that clients do not need to know about the value, which is automatically discovered.

    ## media renderer parameters
    friendlyname = "UpMpd";
    upnpav = 1;
    openhome = 0;
    ##lumincompat = 0
    ##saveohcredentials = 1
    ##checkcontentformat = 1
    ##iconpath = /usr/share/upmpdcli/icon.png
    ##cachedir = /var/cache/upmpdcli
    ##presentationhtml = /usr/share/upmpdcli/presentation.html

    ## mpd parameters
    mpdhost = "127.0.0.1";
    mpdport = 6600;
    ##mpdpassword =
    ##ownqueue = 1

  };

  configuration = defaultConf // {
    ### https://www.lesbonscomptes.com/upmpdcli/upmpdcli-manual.html#UPMPDCLI-CONFIGURATION
    pkgdatadir = "${pkgs.upmpdcli}/share/upmpdcli";

  } // cfg.configuration;

  upmpdcliConf = writeText "upmpdcli.conf" (lib.generators.toKeyValue {} configuration);
in {

  options = {

    services.upmpdcli = {

      enable = mkEnableOption "upmpdcli, a music player daemon";

      configuration = mkOption {
        type = types.attrsOf types.unspecified;
        default = defaultConf;
        description = ''
          Key-value pairs that convey parameters about the configuration
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.upmpdcli = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "sound.target" ];
      description = "upmpdcli music player daemon";
      serviceConfig = {
        ExecStart = "${pkgs.upmpdcli}/bin/upmpdcli -c ${upmpdcliConf}";
      };
    };

    users.users.upmpdcli = {
      inherit uid;
      group = "upmpdcli";
      extraGroups = [ "audio" ];
      description = "UpMpd daemon user";
      home = configuration.pkgdatadir;
    };

    users.groups.upmpdcli.gid = gid;


  };

}
