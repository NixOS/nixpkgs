{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{

  ###### interface

  options = {

    services.rpcbind = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable `rpcbind`, an ONC RPC directory service
          notably used by NFS and NIS, and which can be queried
          using the rpcinfo(1) command. `rpcbind` is a replacement for
          `portmap`.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf config.services.rpcbind.enable {
    environment.systemPackages = [ pkgs.rpcbind ];

    systemd.packages = [ pkgs.rpcbind ];

    systemd.services.rpcbind = {
      wantedBy = [ "multi-user.target" ];
      # rpcbind performs a check for /var/run/rpcbind.lock at startup
      # and will crash if /var/run isn't present. In the stock NixOS
      # var.conf tmpfiles configuration file, /var/run is symlinked to
      # /run, so rpcbind can enter a race condition in which /var/run
      # isn't symlinked yet but tries to interact with the path, so
      # controlling the order explicitly here ensures that rpcbind can
      # start successfully. The `wants` instead of `requires` should
      # avoid creating a strict/brittle dependency.
      wants = [ "systemd-tmpfiles-setup.service" ];
      after = [ "systemd-tmpfiles-setup.service" ];
    };

    users.users.rpc = {
      group = "nogroup";
      uid = config.ids.uids.rpc;
    };
  };

}
