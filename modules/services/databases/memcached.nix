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

    };

  };

  ###### implementation

  config = mkIf config.services.memcached.enable {

    users.extraUsers = singleton
      { name = cfg.user;
        description = "Memcached server user";
      };

    environment.systemPackages = [ memcached ];

    systemd.services.memcached =
      { description = "Memcached server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${memcached}/bin/memcached";
          User = cfg.user;
        };
      };
  };

}
