{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.munge;

in

{

  ###### interface

  options = {

    services.munge = {
      enable = lib.mkEnableOption "munge service";

      password = lib.mkOption {
        default = "/etc/munge/munge.key";
        type = lib.types.path;
        description = ''
          The path to a daemon's secret key.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.munge ];

    users.users.munge = {
      description = "Munge daemon user";
      isSystemUser = true;
      group = "munge";
    };

    users.groups.munge = { };

    systemd.services.munged = {
      documentation = [
        "man:munged(8)"
        "man:mungekey(8)"
      ];
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
        "time-sync.target"
      ];
      after = [
        "network-online.target"
        "time-sync.target"
      ];

      path = [
        pkgs.munge
        pkgs.coreutils
      ];

      serviceConfig = {
        ExecStartPre = "+${pkgs.coreutils}/bin/chmod 0400 ${cfg.password}";
        ExecStart = "${pkgs.munge}/bin/munged --foreground --key-file ${cfg.password}";
        User = "munge";
        Group = "munge";
        StateDirectory = "munge";
        StateDirectoryMode = "0711";
        Restart = "on-failure";
        RuntimeDirectory = "munge";
      };

    };

  };

}
