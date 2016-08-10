{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.transmission;
  apparmor = config.security.apparmor.enable;

  fullSettings = {
    "use-incomplete-dir" = cfg.useIncompleteDir;
    "incomplete-dir"     = cfg.incompleteDir;
    "rpc-whitelist"      = concatStringsSep "," cfg.rpcWhitelist;
    "rpc-whitelist-enabled" = (builtins.length cfg.rpcWhitelist > 0);
    "download-dir"       = cfg.downloadDir;
  } // cfg.settings;

  _baseDir = "/var/lib/transmission";
  _settingsDir = "$_baseDir/.config/transmission-daemon";
  _downloadDir = "$_baseDir/Downloads";
  _incompleteDir = "$_baseDir/Downloads/.incomplete";

  settingsFile =  pkgs.writeText "settings.json" (builtins.toJSON fullSettings);

  # # Strings must be quoted, ints and bools must not (for settings.json).
  # toOption = x:
  #   if x == true then "true"
  #   else if x == false then "false"
  #   else if isInt x then toString x
  #   else toString ''"${x}"'';
in
{
  options = {
    services.transmission = rec {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not to enable the headless Transmission BitTorrent daemon.

          Transmission daemon can be controlled via the RPC interface using
          transmission-remote or the WebUI (http://localhost:9091/ by default).
        '';
      };

      settings = mkOption {
        type = types.attrs;
        default = { };
        example = {
          incomplete-dir-enabled = true;
          rpc-whitelist = "127.0.0.1,192.168.*.*";
          umask = 2;
        };
        description = ''
          Attribute set whose fields overwrites fields in settings.json (each
          time the service starts). String values must be quoted, integer and
          boolean values must not.

          See https://trac.transmissionbt.com/wiki/EditConfigFiles for
          documentation.
        '';
      };

      useIncompleteDir = mkOption {
        type = types.bool;
        default = true;
        description = "Should Transmission store incomplete downloads someplace other than downloadDir?";
      };

      rpcWhitelist = mkOption {
        type = types.listOf types.str;
        default = ["127.0.0.1"];
        description = "List of IP addresses to whitelist for the remote daemon";
      };

      user = mkOption {
        type = types.str;
        default = "transmission";
        description = "User account under which Transmission runs.";
      };

      baseDir = mkOption {
        type = types.str;
        default = _baseDir;
        description = "The base directory for the Transmission service";
      };

      downloadDir = mkOption {
        type = types.str;
        default = _downloadDir;
        description = "The directory to download into";
      };
      settingsDir = mkOption {
        type = types.str;
        default = _settingsDir;
        description = "The directory where the daemon settings are stored";
      };

      incompleteDir = mkOption {
        type = types.str;
        default = _incompleteDir;
        description = "The directory to store incomplete downloads in";
      };

      group = mkOption {
        type = types.str;
        default = "transmission";
        description = "Group under which Transmission runs.";
      };

      port = mkOption {
        type = types.int;
        default = 9091;
        description = "TCP port number to run the RPC/web interface.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.transmission = {
      description = "Transmission BitTorrent Service";
      after = [ "local-fs.target" "network.target" ] ++ optional apparmor "apparmor.service";
      requires = mkIf apparmor [ "apparmor.service" ];
      wantedBy = [ "multi-user.target" ];

      # 1) Only the "transmission" user and group have access to torrents.
      # 2) Optionally update/force specific fields into the configuration file.
      serviceConfig.ExecStartPre = ''
        ${pkgs.stdenv.shell} -c "mkdir -p ${cfg.baseDir} ${cfg.settingsDir} ${cfg.downloadDir} ${cfg.incompleteDir} && chmod 770 ${cfg.baseDir} ${cfg.settingsDir}  ${cfg.downloadDir} ${cfg.incompleteDir} && rm -f ${cfg.settingsDir}/settings.json && cp -f ${settingsFile} ${cfg.settingsDir}/settings.json"
      '';
      serviceConfig.ExecStart = "${pkgs.transmission}/bin/transmission-daemon -g ${cfg.settingsDir} -f --port ${toString config.services.transmission.port}";
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      serviceConfig.User = "${cfg.user}";
      serviceConfig.Group = "${cfg.group}";
      # NOTE: transmission has an internal umask that also must be set (in settings.json)
      serviceConfig.UMask = "0002";
    };

    # It's useful to have transmission in path, e.g. for remote control
    environment.systemPackages = [ pkgs.transmission ];

    users.extraGroups = mkIf (cfg.group == "transmission") {
      transmission.gid = config.ids.gids.transmission;
    };

    users.extraUsers = mkIf (cfg.user == "transmission") {
      transmission = {
        group = "transmission";
        uid = config.ids.uids.transmission;
        description = "Transmission BitTorrent user";
        home = cfg.baseDir;
        createHome = true;
      };
    };

    # AppArmor profile
    security.apparmor.profiles = mkIf apparmor [
      (pkgs.writeText "apparmor-transmission-daemon" ''
        #include <tunables/global>

        ${pkgs.transmission}/bin/transmission-daemon {
          #include <abstractions/base>
          #include <abstractions/nameservice>

          ${getLib pkgs.glibc}/lib/*.so                    mr,
          ${getLib pkgs.libevent}/lib/libevent*.so*        mr,
          ${getLib pkgs.curl}/lib/libcurl*.so*             mr,
          ${getLib pkgs.openssl}/lib/libssl*.so*           mr,
          ${getLib pkgs.openssl}/lib/libcrypto*.so*        mr,
          ${getLib pkgs.zlib}/lib/libz*.so*                mr,
          ${getLib pkgs.libssh2}/lib/libssh2*.so*          mr,
          ${getLib pkgs.systemd}/lib/libsystemd*.so*       mr,
          ${getLib pkgs.xz}/lib/liblzma*.so*               mr,
          ${getLib pkgs.libgcrypt}/lib/libgcrypt*.so*      mr,
          ${getLib pkgs.libgpgerror}/lib/libgpg-error*.so* mr,
          ${getLib pkgs.nghttp2}/lib/libnghttp2*.so*       mr,
          ${getLib pkgs.c-ares}/lib/libcares*.so*          mr,
          ${getLib pkgs.libcap}/lib/libcap*.so*            mr,
          ${getLib pkgs.attr}/lib/libattr*.so*             mr,
          ${getLib pkgs.lz4}/lib/liblz4*.so*               mr,

          @{PROC}/sys/kernel/random/uuid   r,
          @{PROC}/sys/vm/overcommit_memory r,

          ${pkgs.openssl}/etc/**                     r,
          ${pkgs.transmission}/share/transmission/** r,

          owner ${cfg.settings.settings-dir}/** rw,

          ${cfg.settings.download-dir}/** rw,
          ${optionalString cfg.settings.incomplete-dir-enabled ''
            ${cfg.settings.incomplete-dir}/** rw,
          ''}
        }
      '')
    ];
  };

}
