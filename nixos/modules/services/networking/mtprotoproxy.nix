{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mtprotoproxy;

  configOpts = {
    PORT = cfg.port;
    USERS = cfg.users;
    SECURE_ONLY = cfg.secureOnly;
  } // lib.optionalAttrs (cfg.adTag != null) { AD_TAG = cfg.adTag; }
    // cfg.extraConfig;

  convertOption = opt:
    if isString opt || isInt opt then
      builtins.toJSON opt
    else if isBool opt then
      if opt then "True" else "False"
    else if isList opt then
      "[" + concatMapStringsSep "," convertOption opt + "]"
    else if isAttrs opt then
      "{" + concatStringsSep "," (mapAttrsToList (name: opt: "${builtins.toJSON name}: ${convertOption opt}") opt) + "}"
    else
      throw "Invalid option type";

  configFile = pkgs.writeText "config.py" (concatStringsSep "\n" (mapAttrsToList (name: opt: "${name} = ${convertOption opt}") configOpts));

in

{

  ###### interface

  options = {

    services.mtprotoproxy = {

      enable = mkEnableOption "mtprotoproxy";

      port = mkOption {
        type = types.port;
        default = 3256;
        description = ''
          TCP port to accept mtproto connections on.
        '';
      };

      users = mkOption {
        type = types.attrsOf types.str;
        example = {
          tg = "00000000000000000000000000000000";
          tg2 = "0123456789abcdef0123456789abcdef";
        };
        description = ''
          Allowed users and their secrets. A secret is a 32 characters long hex string.
        '';
      };

      secureOnly = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Don't allow users to connect in non-secure mode (without random padding).
        '';
      };

      adTag = mkOption {
        type = types.nullOr types.str;
        default = null;
        # Taken from mtproxyproto's repo.
        example = "3c09c680b76ee91a4c25ad51f742267d";
        description = ''
          Tag for advertising that can be obtained from @MTProxybot.
        '';
      };

      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        example = {
          STATS_PRINT_PERIOD = 600;
        };
        description = ''
          Extra configuration options for mtprotoproxy.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.mtprotoproxy = {
      description = "MTProto Proxy Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.mtprotoproxy}/bin/mtprotoproxy ${configFile}";
        DynamicUser = true;
      };
    };

  };

}
