{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.memcached;

  memcached = pkgs.memcached;

in

{

  ###### interface

  options = {

    services.memcached = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable Memcached.
        ";
      };

      user = mkOption {
        default = "memcached";
        description = "The user to run Memcached as";
      };

      listen = mkOption {
        default = "127.0.0.1";
        description = "The IP address to bind to";
      };

      port = mkOption {
        default = 11211;
        description = "The port to bind to";
      };

      socket = mkOption {
        default = "";
        description = "Unix socket path to listen on. Setting this will disable network support";
        example = "/var/run/memcached";
      };

      maxMemory = mkOption {
        default = 64;
        description = "The maximum amount of memory to use for storage, in megabytes.";
      };

      maxConnections = mkOption {
        default = 1024;
        description = "The maximum number of simultaneous connections";
      };

      extraOptions = mkOption {
        default = [];
        description = "A list of extra options that will be added as a suffix when running memcached";
      };
    };

  };

  ###### implementation

  config = mkIf config.services.memcached.enable {

    users.extraUsers.memcached =
      { name = cfg.user;
        uid = config.ids.uids.memcached;
        description = "Memcached server user";
      };

    environment.systemPackages = [ memcached ];

    systemd.services.memcached =
      { description = "Memcached server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart =
            let
              networking = if cfg.socket != ""
                then "-s ${cfg.socket}"
                else "-l ${cfg.listen} -p ${toString cfg.port}";
            in "${memcached}/bin/memcached ${networking} -m ${toString cfg.maxMemory} -c ${toString cfg.maxConnections} ${concatStringsSep " " cfg.extraOptions}";

          User = cfg.user;
        };
      };
  };

}
