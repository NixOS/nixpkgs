{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.memcached;

  memcached = pkgs.memcached;

in

{

  ###### interface

  options = {

    services.memcached = {
      enable = lib.mkEnableOption "Memcached";

      user = lib.mkOption {
        type = lib.types.str;
        default = "memcached";
        description = "The user to run Memcached as";
      };

      listen = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The IP address to bind to.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 11211;
        description = "The port to bind to.";
      };

      enableUnixSocket = lib.mkEnableOption "Unix Domain Socket at /run/memcached/memcached.sock instead of listening on an IP address and port. The `listen` and `port` options are ignored";

      maxMemory = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 64;
        description = "The maximum amount of memory to use for storage, in MiB (1024×1024 bytes).";
      };

      maxConnections = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 1024;
        description = "The maximum number of simultaneous connections.";
      };

      extraOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "A list of extra options that will be added as a suffix when running memcached.";
      };
    };

  };

  ###### implementation

  config = lib.mkIf config.services.memcached.enable {

    users.users = lib.optionalAttrs (cfg.user == "memcached") {
      memcached.description = "Memcached server user";
      memcached.isSystemUser = true;
      memcached.group = "memcached";
    };
    users.groups = lib.optionalAttrs (cfg.user == "memcached") { memcached = { }; };

    environment.systemPackages = [ memcached ];

    systemd.services.memcached = {
      description = "Memcached server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart =
          let
            networking =
              if cfg.enableUnixSocket then
                "-s /run/memcached/memcached.sock"
              else
                "-l ${cfg.listen} -p ${toString cfg.port}";
          in
          "${memcached}/bin/memcached ${networking} -m ${toString cfg.maxMemory} -c ${toString cfg.maxConnections} ${lib.concatStringsSep " " cfg.extraOptions}";

        User = cfg.user;

        # Filesystem access
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RuntimeDirectory = "memcached";
        # Caps
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        # Misc.
        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        MemoryDenyWriteExecute = true;
      };
    };
  };
  imports = [
    (lib.mkRemovedOptionModule [ "services" "memcached" "socket" ] ''
      This option was replaced by a fixed unix socket path at /run/memcached/memcached.sock enabled using services.memcached.enableUnixSocket.
    '')
  ];

}
