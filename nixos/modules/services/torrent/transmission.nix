# NixOS module for Transmission BitTorrent daemon

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.transmission;
  homeDir = "/var/lib/transmission";
  settingsDir = "${homeDir}/.config/transmission-daemon";
  settingsFile = "${settingsDir}/settings.json";

  # Strings must be quoted, ints and bools must not (for settings.json).
  toOption = x:
    if x == true then "true"
    else if x == false then "false"
    else if builtins.isInt x then toString x
    else toString ''\"${x}\"'';

  # All lines in settings.json end with a ',' (comma), except for the last
  # line. This is standard JSON. But a comma can also appear *inside* some
  # fields, notably the "rpc-whitelist" field. This is difficult to handle in
  # sed so we simply ignore it and say that if you want to change the option at
  # the last line of settings.json, you have to do it manually. At this time of
  # writing, the last option is "utp-enable":true.
  attrsToSedArgs = as:
    concatStrings (concatLists (mapAttrsToList (name: value:
      #map (x: '' -e 's=\(\"${name}\":\)[^,]*\(.*\)=\1 ${toOption x}\2=' '') # breaks if comma inside value field
      map (x: '' -e 's=\(\"${name}\":\).*=\1 ${toOption x},=' '') # always append ',' (breaks last line in settings.json)
        (if isList value then value else [value]))
        as));

in

{

  ### configuration

  options = {

    services.transmission = {

      enable = mkOption {
        type = types.uniq types.bool;
        default = false;
        description = ''
          Whether or not to enable the headless Transmission BitTorrent daemon.

          Transmission daemon can be controlled via the RPC interface using
          transmission-remote or the WebUI (http://localhost:9091/ by default).

          Torrents are downloaded to ${homeDir}/Downloads/ by default and are
          accessible to users in the "transmission" group.
        '';
      };

      settings = mkOption {
        type = types.attrs;
        default =
          {
            # for users in group "transmission" to have access to torrents
            umask = 2;
          }
        ;
        example =
          {
            download-dir = "/srv/torrents/";
            incomplete-dir = "/srv/torrents/.incomplete/";
            incomplete-dir-enabled = true;
            rpc-whitelist = "127.0.0.1,192.168.*.*";
            # for users in group "transmission" to have access to torrents
            umask = 2;
          }
        ;
        description = ''
          Attribute set whos fields overwrites fields in settings.json (each
          time the service starts). String values must be quoted, integer and
          boolean values must not.

          See https://trac.transmissionbt.com/wiki/EditConfigFiles for documentation
          and/or look at ${settingsFile}."
        '';
      };

      rpc_port = mkOption {
        type = types.uniq types.int;
        default = 9091;
        description = "TCP port number to run the RPC/web interface.";
      };

      apparmor = mkOption {
        type = types.uniq types.bool;
        default = true;
        description = "Generate apparmor profile for transmission-daemon.";
      };
    };

  };

  ### implementation

  config = mkIf cfg.enable {

    systemd.services.transmission = {
      description = "Transmission BitTorrent Daemon";
      after = [ "network.target" ] ++ optional (config.security.apparmor.enable && cfg.apparmor) "apparmor.service";
      requires = mkIf (config.security.apparmor.enable && cfg.apparmor) [ "apparmor.service" ];
      wantedBy = [ "multi-user.target" ];

      # 1) Only the "transmission" user and group have access to torrents.
      # 2) Optionally update/force specific fields into the configuration file.
      serviceConfig.ExecStartPre =
        if cfg.settings != {} then ''
          ${pkgs.stdenv.shell} -c "chmod 770 ${homeDir} && mkdir -p ${settingsDir} && ${pkgs.transmission}/bin/transmission-daemon -d |& sed ${attrsToSedArgs cfg.settings} > ${settingsFile}.tmp && mv ${settingsFile}.tmp ${settingsFile}"
        ''
        else ''
          ${pkgs.stdenv.shell} -c "chmod 770 ${homeDir}"
        '';
      serviceConfig.ExecStart = "${pkgs.transmission}/bin/transmission-daemon -f --port ${toString config.services.transmission.rpc_port}";
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      serviceConfig.User = "transmission";
      # NOTE: transmission has an internal umask that also must be set (in settings.json)
      serviceConfig.UMask = "0002";
    };

    # It's useful to have transmission in path, e.g. for remote control
    environment.systemPackages = [ pkgs.transmission ];

    users.extraUsers.transmission = {
      group = "transmission";
      uid = config.ids.uids.transmission;
      description = "Transmission BitTorrent user";
      home = homeDir;
      createHome = true;
    };

    users.extraGroups.transmission.gid = config.ids.gids.transmission;

    # AppArmor profile
    security.apparmor.profiles = mkIf (config.security.apparmor.enable && cfg.apparmor) [
      (pkgs.writeText "apparmor-transmission-daemon" ''
        #include <tunables/global>

        ${pkgs.transmission}/bin/transmission-daemon {
          #include <abstractions/base>
          #include <abstractions/nameservice>

          ${pkgs.glibc}/lib/*.so             mr,
          ${pkgs.libevent}/lib/libevent*.so* mr,
          ${pkgs.curl}/lib/libcurl*.so*      mr,
          ${pkgs.openssl}/lib/libssl*.so*    mr,
          ${pkgs.openssl}/lib/libcrypto*.so* mr,
          ${pkgs.zlib}/lib/libz*.so*         mr,
          ${pkgs.libssh2}/lib/libssh2*.so*   mr,

          @{PROC}/sys/kernel/random/uuid   r,
          @{PROC}/sys/vm/overcommit_memory r,

          ${pkgs.transmission}/share/transmission/** r,

          owner ${settingsDir}/** rw,

          ${cfg.settings.download-dir}/** rw,
          ${optionalString cfg.settings.incomplete-dir-enabled ''
            ${cfg.settings.incomplete-dir}/** rw,
          ''}
        }
      '')
    ];
  };

}
