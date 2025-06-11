{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.mpdscribble;
  mpdCfg = config.services.mpd;
  mpdOpt = options.services.mpd;

  endpointUrls = {
    "last.fm" = "http://post.audioscrobbler.com";
    "libre.fm" = "http://turtle.libre.fm";
    "jamendo" = "http://postaudioscrobbler.jamendo.com";
    "listenbrainz" = "http://proxy.listenbrainz.org";
  };

  mkSection = secname: secCfg: ''
    [${secname}]
    url      = ${secCfg.url}
    username = ${secCfg.username}
    password = {{${secname}_PASSWORD}}
    journal  = /var/lib/mpdscribble/${secname}.journal
  '';

  endpoints = lib.concatStringsSep "\n" (lib.mapAttrsToList mkSection cfg.endpoints);
  cfgTemplate = pkgs.writeText "mpdscribble.conf" ''
    ## This file was automatically genenrated by NixOS and will be overwritten.
    ## Do not edit. Edit your NixOS configuration instead.

    ## mpdscribble - an audioscrobbler for the Music Player Daemon.
    ## http://mpd.wikia.com/wiki/Client:mpdscribble

    # HTTP proxy URL.
    ${lib.optionalString (cfg.proxy != null) "proxy = ${cfg.proxy}"}

    # The location of the mpdscribble log file.  The special value
    # "syslog" makes mpdscribble use the local syslog daemon.  On most
    # systems, log messages will appear in /var/log/daemon.log then.
    # "-" means log to stderr (the current terminal).
    log = -

    # How verbose mpdscribble's logging should be.  Default is 1.
    verbose = ${toString cfg.verbose}

    # How often should mpdscribble save the journal file? [seconds]
    journal_interval = ${toString cfg.journalInterval}

    # The host running MPD, possibly protected by a password
    # ([PASSWORD@]HOSTNAME).
    host = ${(lib.optionalString (cfg.passwordFile != null) "{{MPD_PASSWORD}}@") + cfg.host}

    # The port that the MPD listens on and mpdscribble should try to
    # connect to.
    port = ${toString cfg.port}

    ${endpoints}
  '';

  cfgFile = "/run/mpdscribble/mpdscribble.conf";

  replaceSecret =
    secretFile: placeholder: targetFile:
    lib.optionalString (
      secretFile != null
    ) ''${pkgs.replace-secret}/bin/replace-secret '${placeholder}' '${secretFile}' '${targetFile}' '';

  preStart = pkgs.writeShellScript "mpdscribble-pre-start" ''
    cp -f "${cfgTemplate}" "${cfgFile}"
    ${replaceSecret cfg.passwordFile "{{MPD_PASSWORD}}" cfgFile}
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        secname: cfg: replaceSecret cfg.passwordFile "{{${secname}_PASSWORD}}" cfgFile
      ) cfg.endpoints
    )}
  '';

  localMpd = (cfg.host == "localhost" || cfg.host == "127.0.0.1");

in
{
  ###### interface

  options.services.mpdscribble = {

    enable = lib.mkEnableOption "mpdscribble, an MPD client which submits info about tracks being played to Last.fm (formerly AudioScrobbler)";

    proxy = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = ''
        HTTP proxy URL.
      '';
    };

    verbose = lib.mkOption {
      default = 1;
      type = lib.types.int;
      description = ''
        Log level for the mpdscribble daemon.
      '';
    };

    journalInterval = lib.mkOption {
      default = 600;
      example = 60;
      type = lib.types.int;
      description = ''
        How often should mpdscribble save the journal file? [seconds]
      '';
    };

    host = lib.mkOption {
      default = (
        if mpdCfg.network.listenAddress != "any" then mpdCfg.network.listenAddress else "localhost"
      );
      defaultText = lib.literalExpression ''
        if config.${mpdOpt.network.listenAddress} != "any"
        then config.${mpdOpt.network.listenAddress}
        else "localhost"
      '';
      type = lib.types.str;
      description = ''
        Host for the mpdscribble daemon to search for a mpd daemon on.
      '';
    };

    passwordFile = lib.mkOption {
      default =
        if localMpd then
          (lib.findFirst (c: lib.any (x: x == "read") c.permissions) {
            passwordFile = null;
          } mpdCfg.credentials).passwordFile
        else
          null;
      defaultText = lib.literalMD ''
        The first password file with read access configured for MPD when using a local instance,
        otherwise `null`.
      '';
      type = lib.types.nullOr lib.types.str;
      description = ''
        File containing the password for the mpd daemon.
        If there is a local mpd configured using {option}`services.mpd.credentials`
        the default is automatically set to a matching passwordFile of the local mpd.
      '';
    };

    port = lib.mkOption {
      default = mpdCfg.network.port;
      defaultText = lib.literalExpression "config.${mpdOpt.network.port}";
      type = lib.types.port;
      description = ''
        Port for the mpdscribble daemon to search for a mpd daemon on.
      '';
    };

    endpoints = lib.mkOption {
      type = (
        let
          endpoint =
            { name, ... }:
            {
              options = {
                url = lib.mkOption {
                  type = lib.types.str;
                  default = endpointUrls.${name} or "";
                  description = "The url endpoint where the scrobble API is listening.";
                };
                username = lib.mkOption {
                  type = lib.types.str;
                  description = ''
                    Username for the scrobble service.
                  '';
                };
                passwordFile = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  description = "File containing the password, either as MD5SUM or cleartext.";
                };
              };
            };
        in
        lib.types.attrsOf (lib.types.submodule endpoint)
      );
      default = { };
      example = {
        "last.fm" = {
          username = "foo";
          passwordFile = "/run/secrets/lastfm_password";
        };
      };
      description = ''
        Endpoints to scrobble to.
        If the endpoint is one of "${lib.concatStringsSep "\", \"" (lib.attrNames endpointUrls)}" the url is set automatically.
      '';
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    systemd.services.mpdscribble = {
      after = [ "network.target" ] ++ (lib.optional localMpd "mpd.service");
      description = "mpdscribble mpd scrobble client";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "mpdscribble";
        RuntimeDirectory = "mpdscribble";
        RuntimeDirectoryMode = "700";
        # TODO use LoadCredential= instead of running preStart with full privileges?
        ExecStartPre = "+${preStart}";
        ExecStart = "${pkgs.mpdscribble}/bin/mpdscribble --no-daemon --conf ${cfgFile}";
      };
    };
  };

}
