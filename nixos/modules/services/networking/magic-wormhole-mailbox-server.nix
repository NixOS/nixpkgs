{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.magic-wormhole-mailbox-server;
  dataDir = "/var/lib/magic-wormhole-mailbox-server;";
  python = pkgs.python3.withPackages (py: [ py.magic-wormhole-mailbox-server py.twisted ]);
in
{
  options.services.magic-wormhole-mailbox-server = {
    enable = mkEnableOption (lib.mdDoc "Magic Wormhole Mailbox Server");
  };

  config = mkIf cfg.enable {
    systemd.services.magic-wormhole-mailbox-server = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${python}/bin/twistd --nodaemon wormhole-mailbox";
        WorkingDirectory = dataDir;
        StateDirectory = baseNameOf dataDir;
      };
    };

  };
}
