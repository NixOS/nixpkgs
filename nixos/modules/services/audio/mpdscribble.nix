{ config, lib, options, pkgs, ... }:

with lib;

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

  endpoints = concatStringsSep "\n" (mapAttrsToList mkSection cfg.endpoints);
  cfgTemplate = pkgs.writeText "mpdscribble.conf" ''
    ## This file was automatically genenrated by NixOS and will be overwritten.
    ## Do not edit. Edit your NixOS configuration instead.

    ## mpdscribble - an audioscrobbler for the Music Player Daemon.
    ## http://mpd.wikia.com/wiki/Client:mpdscribble

    # HTTP proxy URL.
    ${optionalString (cfg.proxy != null) "proxy = ${cfg.proxy}"}

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
    host = ${(optionalString (cfg.passwordFile != null) "{{MPD_PASSWORD}}@") + cfg.host}

    # The port that the MPD listens on and mpdscribble should try to
    # connect to.
    port = ${toString cfg.port}

    ${endpoints}
  '';

  cfgFile = "/run/mpdscribble/mpdscribble.conf";

  replaceSecret = secretFile: placeholder: targetFile:
    optionalString (secretFile != null) ''
      ${pkgs.replace-secret}/bin/replace-secret '${placeholder}' '${secretFile}' '${targetFile}' '';

  preStart = pkgs.writeShellScript "mpdscribble-pre-start" ''
    cp -f "${cfgTemplate}" "${cfgFile}"
    ${replaceSecret cfg.passwordFile "{{MPD_PASSWORD}}" cfgFile}
    ${concatStringsSep "\n" (mapAttrsToList (secname: cfg:
      replaceSecret cfg.passwordFile "{{${secname}_PASSWORD}}" cfgFile)
      cfg.endpoints)}
  '';

  localMpd = (cfg.host == "localhost" || cfg.host == "127.0.0.1");

in {
  ###### interface

  options.services.mpdscribble = {

    enable = mkEnableOption (lib.mdDoc "mpdscribble");

    proxy = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = lib.mdDoc ''
        HTTP proxy URL.
      '';
    };

    verbose = mkOption {
      default = 1;
      type = types.int;
      description = lib.mdDoc ''
        Log level for the mpdscribble daemon.
      '';
    };

    journalInterval = mkOption {
      default = 600;
      example = 60;
      type = types.int;
      description = lib.mdDoc ''
        How often should mpdscribble save the journal file? [seconds]
      '';
    };

    host = mkOption {
      default = (if mpdCfg.network.listenAddress != "any" then
        mpdCfg.network.listenAddress
      else
        "localhost");
      defaultText = literalExpression ''
        if config.${mpdOpt.network.listenAddress} != "any"
        then config.${mpdOpt.network.listenAddress}
        else "localhost"
      '';
      type = types.str;
      description = lib.mdDoc ''
        Host for the mpdscribble daemon to search for a mpd daemon on.
      '';
    };

    passwordFile = mkOption {
      default = if localMpd then
        (findFirst
          (c: any (x: x == "read") c.permissions)
          { passwordFile = null; }
          mpdCfg.credentials).passwordFile
      else
        null;
      defaultText = literalMD ''
        The first password file with read access configured for MPD when using a local instance,
        otherwise `null`.
      '';
      type = types.nullOr types.str;
      description = lib.mdDoc ''
        File containing the password for the mpd daemon.
        If there is a local mpd configured using {option}`services.mpd.credentials`
        the default is automatically set to a matching passwordFile of the local mpd.
      '';
    };

    port = mkOption {
      default = mpdCfg.network.port;
      defaultText = literalExpression "config.${mpdOpt.network.port}";
      type = types.port;
      description = lib.mdDoc ''
        Port for the mpdscribble daemon to search for a mpd daemon on.
      '';
    };

    endpoints = mkOption {
      type = (let
        endpoint = { name, ... }: {
          options = {
            url = mkOption {
              type = types.str;
              default = endpointUrls.${name} or "";
              description =
                lib.mdDoc "The url endpoint where the scrobble API is listening.";
            };
            username = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Username for the scrobble service.
              '';
            };
            passwordFile = mkOption {
              type = types.nullOr types.str;
              description =
                lib.mdDoc "File containing the password, either as MD5SUM or cleartext.";
            };
          };
        };
      in types.attrsOf (types.submodule endpoint));
      default = { };
      example = {
        "last.fm" = {
          username = "foo";
          passwordFile = "/run/secrets/lastfm_password";
        };
      };
      description = lib.mdDoc ''
        Endpoints to scrobble to.
        If the endpoint is one of "${
          concatStringsSep "\", \"" (attrNames endpointUrls)
        }" the url is set automatically.
      '';
    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.mpdscribble = {
      after = [ "network.target" ] ++ (optional localMpd "mpd.service");
      description = "mpdscribble mpd scrobble client";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "mpdscribble";
        RuntimeDirectory = "mpdscribble";
        RuntimeDirectoryMode = "700";
        # TODO use LoadCredential= instead of running preStart with full privileges?
        ExecStartPre = "+${preStart}";
        ExecStart =
          "${pkgs.mpdscribble}/bin/mpdscribble --no-daemon --conf ${cfgFile}";
      };
    };
  };

}
