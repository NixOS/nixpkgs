{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.mtprotoproxy;

  configOpts =
    {
      PORT = cfg.port;
      USERS = cfg.users;
      SECURE_ONLY = cfg.secureOnly;
    }
    // lib.optionalAttrs (cfg.adTag != null) { AD_TAG = cfg.adTag; }
    // cfg.extraConfig;

  convertOption =
    opt:
    if lib.isString opt || lib.isInt opt then
      builtins.toJSON opt
    else if lib.isBool opt then
      if opt then "True" else "False"
    else if lib.isList opt then
      "[" + lib.concatMapStringsSep "," convertOption opt + "]"
    else if lib.isAttrs opt then
      "{"
      + lib.concatStringsSep "," (
        lib.mapAttrsToList (name: opt: "${builtins.toJSON name}: ${convertOption opt}") opt
      )
      + "}"
    else
      throw "Invalid option type";

  configFile = pkgs.writeText "config.py" (
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: opt: "${name} = ${convertOption opt}") configOpts)
  );

in

{

  ###### interface

  options = {

    services.mtprotoproxy = {

      enable = lib.mkEnableOption "mtprotoproxy";

      port = lib.mkOption {
        type = lib.types.port;
        default = 3256;
        description = ''
          TCP port to accept mtproto connections on.
        '';
      };

      users = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        example = {
          tg = "00000000000000000000000000000000";
          tg2 = "0123456789abcdef0123456789abcdef";
        };
        description = ''
          Allowed users and their secrets. A secret is a 32 characters long hex string.
        '';
      };

      secureOnly = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Don't allow users to connect in non-secure mode (without random padding).
        '';
      };

      adTag = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        # Taken from mtproxyproto's repo.
        example = "3c09c680b76ee91a4c25ad51f742267d";
        description = ''
          Tag for advertising that can be obtained from @MTProxybot.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
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

  config = lib.mkIf cfg.enable {

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
