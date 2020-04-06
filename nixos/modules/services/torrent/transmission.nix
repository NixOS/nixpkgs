{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.transmission;
  apparmor = config.security.apparmor.enable;

  homeDir = cfg.home;
  downloadDirPermissions = cfg.downloadDirPermissions;
  downloadDir = "${homeDir}/Downloads";
  incompleteDir = "${homeDir}/.incomplete";

  settingsDir = "${homeDir}/.config/transmission-daemon";
  settingsFile = pkgs.writeText "settings.json" (builtins.toJSON fullSettings);

  # for users in group "transmission" to have access to torrents
  fullSettings = { umask = 2; download-dir = downloadDir; incomplete-dir = incompleteDir; } // cfg.settings;

  preStart = pkgs.writeScript "transmission-pre-start" ''
    #!${pkgs.runtimeShell}
    set -ex
    for DIR in "${homeDir}" "${settingsDir}" "${fullSettings.download-dir}" "${fullSettings.incomplete-dir}"; do
      mkdir -p "$DIR"
    done
    chmod 755 "${homeDir}"
    chmod 700 "${settingsDir}"
    chmod ${downloadDirPermissions} "${fullSettings.download-dir}" "${fullSettings.incomplete-dir}"
    cp -f ${settingsFile} ${settingsDir}/settings.json
  '';
in
{
  options = {
    services.transmission = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not to enable the headless Transmission BitTorrent daemon.

          Transmission daemon can be controlled via the RPC interface using
          transmission-remote or the WebUI (http://localhost:9091/ by default).

          Torrents are downloaded to ${downloadDir} by default and are
          accessible to users in the "transmission" group.
        '';
      };

      settings = mkOption {
        type = types.attrs;
        default =
          {
            download-dir = downloadDir;
            incomplete-dir = incompleteDir;
            incomplete-dir-enabled = true;
          };
        example =
          {
            download-dir = "/srv/torrents/";
            incomplete-dir = "/srv/torrents/.incomplete/";
            incomplete-dir-enabled = true;
            rpc-whitelist = "127.0.0.1,192.168.*.*";
          };
        description = ''
          Attribute set whos fields overwrites fields in settings.json (each
          time the service starts). String values must be quoted, integer and
          boolean values must not.

          See https://github.com/transmission/transmission/wiki/Editing-Configuration-Files
          for documentation.
        '';
      };

      downloadDirPermissions = mkOption {
        type = types.str;
        default = "770";
        example = "775";
        description = ''
          The permissions to set for download-dir and incomplete-dir.
          They will be applied on every service start.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 9091;
        description = "TCP port number to run the RPC/web interface.";
      };

      home = mkOption {
        type = types.path;
        default = "/var/lib/transmission";
        description = ''
          The directory where transmission will create files.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "transmission";
        description = "User account under which Transmission runs.";
      };

      group = mkOption {
        type = types.str;
        default = "transmission";
        description = "Group account under which Transmission runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.transmission = {
      description = "Transmission BitTorrent Service";
      after = [ "network.target" ] ++ optional apparmor "apparmor.service";
      requires = mkIf apparmor [ "apparmor.service" ];
      wantedBy = [ "multi-user.target" ];

      # 1) Only the "transmission" user and group have access to torrents.
      # 2) Optionally update/force specific fields into the configuration file.
      serviceConfig.ExecStartPre = preStart;
      serviceConfig.ExecStart = "${pkgs.transmission}/bin/transmission-daemon -f --port ${toString config.services.transmission.port} --config-dir ${settingsDir}";
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      serviceConfig.User = cfg.user;
      serviceConfig.Group = cfg.group;
      # NOTE: transmission has an internal umask that also must be set (in settings.json)
      serviceConfig.UMask = "0002";
    };

    # It's useful to have transmission in path, e.g. for remote control
    environment.systemPackages = [ pkgs.transmission ];

    users.users = optionalAttrs (cfg.user == "transmission") ({
      transmission = {
        name = "transmission";
        group = cfg.group;
        uid = config.ids.uids.transmission;
        description = "Transmission BitTorrent user";
        home = homeDir;
        createHome = true;
      };
    });

    users.groups = optionalAttrs (cfg.group == "transmission") ({
      transmission = {
        name = "transmission";
        gid = config.ids.gids.transmission;
      };
    });

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
          ${getLib pkgs.libkrb5}/lib/lib*.so*              mr,
          ${getLib pkgs.keyutils}/lib/libkeyutils*.so*     mr,
          ${getLib pkgs.utillinuxMinimal.out}/lib/libblkid.so.* mr,
          ${getLib pkgs.utillinuxMinimal.out}/lib/libmount.so.* mr,
          ${getLib pkgs.utillinuxMinimal.out}/lib/libuuid.so.* mr,

          @{PROC}/sys/kernel/random/uuid   r,
          @{PROC}/sys/vm/overcommit_memory r,

          ${pkgs.openssl.out}/etc/**                     r,
          ${pkgs.transmission}/share/transmission/** r,

          owner ${settingsDir}/** rw,

          ${fullSettings.download-dir}/** rw,
          ${optionalString fullSettings.incomplete-dir-enabled ''
            ${fullSettings.incomplete-dir}/** rw,
          ''}
        }
      '')
    ];
  };

}
