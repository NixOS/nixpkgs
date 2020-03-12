{ config, lib, pkgs, ... }:

with lib;

let

  gid = config.ids.gids.mediatomb;
  cfg = config.services.mediatomb;
  name = cfg.package.pname;
  pkg = cfg.package;
  optionYesNo = option: if option then "yes" else "no";

  mtConf = pkgs.writeText "config.xml" ''
  <?xml version="1.0" encoding="UTF-8"?>
  <config version="2" xmlns="http://mediatomb.cc/config/2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://mediatomb.cc/config/2 http://mediatomb.cc/config/2.xsd">
    <interface>${cfg.interface}</interface>
    <server>
      <ui enabled="yes" show-tooltips="yes">
        <accounts enabled="no" session-timeout="30">
          <account user="${name}" password="${name}"/>
        </accounts>
      </ui>
      <name>${cfg.serverName}</name>
      <udn>uuid:${cfg.uuid}</udn>
      <home>${cfg.dataDir}</home>
      <interface>${cfg.interface}</interface>
      <webroot>${pkg}/share/${name}/web</webroot>
      <storage>
        <sqlite3 enabled="yes">
          <database-file>${name}.db</database-file>
        </sqlite3>
      </storage>
      <protocolInfo extend="${optionYesNo cfg.ps3Support}"/>
      ${lib.optionalString cfg.dsmSupport ''
      <custom-http-headers>
        <add header="X-User-Agent: redsonic"/>
      </custom-http-headers>

      <manufacturerURL>redsonic.com</manufacturerURL>
      <modelNumber>105</modelNumber>
      ''}
        ${optionalString cfg.tg100Support ''
      <upnp-string-limit>101</upnp-string-limit>
      ''}
      <extended-runtime-options>
        <mark-played-items enabled="yes" suppress-cds-updates="yes">
          <string mode="prepend">*</string>
          <mark>
            <content>video</content>
          </mark>
        </mark-played-items>
      </extended-runtime-options>
    </server>
    <import hidden-files="no">
      <scripting script-charset="UTF-8">
        <common-script>${pkg}/share/${name}/js/common.js</common-script>
        <playlist-script>${pkg}/share/${name}/js/playlists.js</playlist-script>
        <virtual-layout type="builtin">
          <import-script>${pkg}/share/${name}/js/import.js</import-script>
        </virtual-layout>
      </scripting>
      <mappings>
        <extension-mimetype ignore-unknown="no">
          <map from="mp3" to="audio/mpeg"/>
          <map from="ogx" to="application/ogg"/>
          <map from="ogv" to="video/ogg"/>
          <map from="oga" to="audio/ogg"/>
          <map from="ogg" to="audio/ogg"/>
          <map from="ogm" to="video/ogg"/>
          <map from="asf" to="video/x-ms-asf"/>
          <map from="asx" to="video/x-ms-asf"/>
          <map from="wma" to="audio/x-ms-wma"/>
          <map from="wax" to="audio/x-ms-wax"/>
          <map from="wmv" to="video/x-ms-wmv"/>
          <map from="wvx" to="video/x-ms-wvx"/>
          <map from="wm" to="video/x-ms-wm"/>
          <map from="wmx" to="video/x-ms-wmx"/>
          <map from="m3u" to="audio/x-mpegurl"/>
          <map from="pls" to="audio/x-scpls"/>
          <map from="flv" to="video/x-flv"/>
          <map from="mkv" to="video/x-matroska"/>
          <map from="mka" to="audio/x-matroska"/>
          ${optionalString cfg.ps3Support ''
          <map from="avi" to="video/divx"/>
          ''}
          ${optionalString cfg.dsmSupport ''
          <map from="avi" to="video/avi"/>
          ''}
        </extension-mimetype>
        <mimetype-upnpclass>
          <map from="audio/*" to="object.item.audioItem.musicTrack"/>
          <map from="video/*" to="object.item.videoItem"/>
          <map from="image/*" to="object.item.imageItem"/>
        </mimetype-upnpclass>
        <mimetype-contenttype>
          <treat mimetype="audio/mpeg" as="mp3"/>
          <treat mimetype="application/ogg" as="ogg"/>
          <treat mimetype="audio/ogg" as="ogg"/>
          <treat mimetype="audio/x-flac" as="flac"/>
          <treat mimetype="audio/x-ms-wma" as="wma"/>
          <treat mimetype="audio/x-wavpack" as="wv"/>
          <treat mimetype="image/jpeg" as="jpg"/>
          <treat mimetype="audio/x-mpegurl" as="playlist"/>
          <treat mimetype="audio/x-scpls" as="playlist"/>
          <treat mimetype="audio/x-wav" as="pcm"/>
          <treat mimetype="audio/L16" as="pcm"/>
          <treat mimetype="video/x-msvideo" as="avi"/>
          <treat mimetype="video/mp4" as="mp4"/>
          <treat mimetype="audio/mp4" as="mp4"/>
          <treat mimetype="application/x-iso9660" as="dvd"/>
          <treat mimetype="application/x-iso9660-image" as="dvd"/>
        </mimetype-contenttype>
      </mappings>
      <online-content>
        <YouTube enabled="no" refresh="28800" update-at-start="no" purge-after="604800" racy-content="exclude" format="mp4" hd="no">
          <favorites user="${name}"/>
          <standardfeed feed="most_viewed" time-range="today"/>
          <playlists user="${name}"/>
          <uploads user="${name}"/>
          <standardfeed feed="recently_featured" time-range="today"/>
        </YouTube>
      </online-content>
    </import>
    <transcoding enabled="${if cfg.transcoding then "yes" else "no"}">
      <mimetype-profile-mappings>
        <transcode mimetype="video/x-flv" using="vlcmpeg"/>
        <transcode mimetype="application/ogg" using="vlcmpeg"/>
        <transcode mimetype="application/ogg" using="oggflac2raw"/>
        <transcode mimetype="audio/x-flac" using="oggflac2raw"/>
      </mimetype-profile-mappings>
      <profiles>
        <profile name="oggflac2raw" enabled="no" type="external">
          <mimetype>audio/L16</mimetype>
          <accept-url>no</accept-url>
          <first-resource>yes</first-resource>
          <accept-ogg-theora>no</accept-ogg-theora>
          <agent command="ogg123" arguments="-d raw -o byteorder:big -f %out %in"/>
          <buffer size="1048576" chunk-size="131072" fill-size="262144"/>
        </profile>
        <profile name="vlcmpeg" enabled="no" type="external">
          <mimetype>video/mpeg</mimetype>
          <accept-url>yes</accept-url>
          <first-resource>yes</first-resource>
          <accept-ogg-theora>yes</accept-ogg-theora>
          <agent command="vlc" arguments="-I dummy %in --sout #transcode{venc=ffmpeg,vcodec=mp2v,vb=4096,fps=25,aenc=ffmpeg,acodec=mpga,ab=192,samplerate=44100,channels=2}:standard{access=file,mux=ps,dst=%out} vlc:quit"/>
          <buffer size="14400000" chunk-size="512000" fill-size="120000"/>
        </profile>
      </profiles>
    </transcoding>
  </config>
  '';

in {


  ###### interface

  options = {

    services.mediatomb = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Gerbera/Mediatomb DLNA server.
        '';
      };

      serverName = mkOption {
        type = types.str;
        default = "Gerbera (Mediatomb)";
        description = ''
          How to identify the server on the network.
        '';
      };

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.mediatomb";
        default = pkgs.gerbera;
        description = ''
          Underlying package to be used with the module (default: pkgs.gerbera).
        '';
      };

      ps3Support = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable ps3 specific tweaks.
          WARNING: incompatible with DSM 320 support.
        '';
      };

      dsmSupport = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable D-Link DSM 320 specific tweaks.
          WARNING: incompatible with ps3 support.
        '';
      };

      tg100Support = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Telegent TG100 specific tweaks.
        '';
      };

      transcoding = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable transcoding.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/${name}";
        description = ''
          The directory where ${cfg.serverName} stores its state, data, etc.
        '';
      };

      user = mkOption {
        default = "mediatomb";
        description = "User account under which ${name} runs.";
      };

      group = mkOption {
        default = "mediatomb";
        description = "Group account under which ${name} runs.";
      };

      port = mkOption {
        default = 49152;
        description = ''
          The network port to listen on.
        '';
      };

      interface = mkOption {
        default = "";
        description = ''
          A specific interface to bind to.
        '';
      };

      uuid = mkOption {
        default = "fdfc8a4e-a3ad-4c1d-b43d-a2eedb03a687";
        description = ''
          A unique (on your network) to identify the server by.
        '';
      };

      customCfg = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allow ${name} to create and use its own config file inside ${cfg.dataDir}.
          Deactivated by default, the service then runs with the configuration generated from this module.
          Otherwise, when enabled, no service configuration is generated. Gerbera/Mediatomb then starts using
          ${cfg.dataDir}/config.xml. It's up to the user to make a correct configuration file.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services."${name}"= {
      description = "${cfg.serverName} media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkg}/bin/${name} -p ${toString cfg.port} ${if cfg.interface!="" then "-e ${cfg.interface}" else ""} ${if cfg.customCfg then "" else "-c ${mtConf}"} -m ${cfg.dataDir}";
      serviceConfig.User = "${cfg.user}";
    };

    users.groups = optionalAttrs (cfg.group == "mediatomb") {
      mediatomb.gid = gid;
    };

    users.users = optionalAttrs (cfg.user == "mediatomb") {
      mediatomb = {
        isSystemUser = true;
        group = cfg.group;
        home = "${cfg.dataDir}";
        createHome = true;
        description = "${name} DLNA Server User";
      };
    };

    networking.firewall.interfaces."${cfg.interface}" = {
      allowedUDPPorts = [ 1900 cfg.port ];
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
