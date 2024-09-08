{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.magic-wormhole-mailbox-server;
  # keep semicolon in dataDir for backward compatibility
  dataDir = "/var/lib/magic-wormhole-mailbox-server;";
  python = pkgs.python311.withPackages (
    py: with py; [
      magic-wormhole-mailbox-server
      twisted
    ]
  );
in
{
  options.services.magic-wormhole-mailbox-server = {
    enable = lib.mkEnableOption "Magic Wormhole Mailbox Server";
  };

  config = lib.mkIf cfg.enable {
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

  meta.maintainers = [ lib.maintainers.mjoerg ];
}
