{ config, lib, pkgs, ... }:

let
  cfg = config.services.shadowsocks;

  opts = {
    server = cfg.localAddress;
    server_port = cfg.port;
    method = cfg.encryptionMethod;
    mode = cfg.mode;
    user = "nobody";
    fast_open = cfg.fastOpen;
  } // lib.optionalAttrs (cfg.plugin != null) {
    plugin = cfg.plugin;
    plugin_opts = cfg.pluginOpts;
  } // lib.optionalAttrs (cfg.password != null) {
    password = cfg.password;
  } // cfg.extraConfig;

  configFile = pkgs.writeText "shadowsocks.json" (builtins.toJSON opts);

in

{

  ###### interface

  options = {

    services.shadowsocks = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run shadowsocks-libev shadowsocks server.
        '';
      };

      localAddress = lib.mkOption {
        type = lib.types.coercedTo lib.types.str lib.singleton (lib.types.listOf lib.types.str);
        default = [ "[::0]" "0.0.0.0" ];
        description = ''
          Local addresses to which the server binds.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8388;
        description = ''
          Port which the server uses.
        '';
      };

      password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Password for connecting clients.
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Password file with a password for connecting clients.
        '';
      };

      mode = lib.mkOption {
        type = lib.types.enum [ "tcp_only" "tcp_and_udp" "udp_only" ];
        default = "tcp_and_udp";
        description = ''
          Relay protocols.
        '';
      };

      fastOpen = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          use TCP fast-open
        '';
      };

      encryptionMethod = lib.mkOption {
        type = lib.types.str;
        default = "chacha20-ietf-poly1305";
        description = ''
          Encryption method. See <https://github.com/shadowsocks/shadowsocks-org/wiki/AEAD-Ciphers>.
        '';
      };

      plugin = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = lib.literalExpression ''"''${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin"'';
        description = ''
          SIP003 plugin for shadowsocks
        '';
      };

      pluginOpts = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "server;host=example.com";
        description = ''
          Options to pass to the plugin if one was specified
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        example = {
          nameserver = "8.8.8.8";
        };
        description = ''
          Additional configuration for shadowsocks that is not covered by the
          provided options. The provided attrset will be serialized to JSON and
          has to contain valid shadowsocks options. Unfortunately most
          additional options are undocumented but it's easy to find out what is
          available by looking into the source code of
          <https://github.com/shadowsocks/shadowsocks-libev/blob/master/src/jconf.c>
        '';
      };
    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        # xor, make sure either password or passwordFile be set.
        # shadowsocks-libev not support plain/none encryption method
        # which indicated that password must set.
        assertion = let noPasswd = cfg.password == null; noPasswdFile = cfg.passwordFile == null;
          in (noPasswd && !noPasswdFile) || (!noPasswd && noPasswdFile);
        message = "Option `password` or `passwordFile` must be set and cannot be set simultaneously";
      }
    ];

    systemd.services.shadowsocks-libev = {
      description = "shadowsocks-libev Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.shadowsocks-libev ] ++ lib.optional (cfg.plugin != null) cfg.plugin ++ lib.optional (cfg.passwordFile != null) pkgs.jq;
      serviceConfig.PrivateTmp = true;
      script = ''
        ${lib.optionalString (cfg.passwordFile != null) ''
          cat ${configFile} | jq --arg password "$(cat "${cfg.passwordFile}")" '. + { password: $password }' > /tmp/shadowsocks.json
        ''}
        exec ss-server -c ${if cfg.passwordFile != null then "/tmp/shadowsocks.json" else configFile}
      '';
    };
  };
}
