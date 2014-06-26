{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitolite;
  pubkeyFile = pkgs.writeText "gitolite-admin.pub" cfg.adminPubkey;
in
{
  options = {
    services.gitolite = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable gitolite management under the
          <literal>gitolite</literal> user. The Gitolite home
          directory is <literal>/var/lib/gitolite</literal>. After
          switching to a configuration with Gitolite enabled, you can
          then run <literal>git clone
          gitolite@host:gitolite-admin.git</literal> to manage it further.
        '';
      };

      adminPubkey = mkOption {
        type = types.str;
        description = ''
          Initial administrative public key for Gitolite. This should
          be an SSH Public Key. Note that this key will only be used
          once, upon the first initialization of the Gitolite user.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.gitolite = {
      description     = "Gitolite user";
      home            = "/var/lib/gitolite";
      createHome      = true;
      uid             = config.ids.uids.gitolite;
      useDefaultShell = true;
    };

    systemd.services."gitolite-init" = {
      description = "Gitolite initialization";
      wantedBy    = [ "multi-user.target" ];

      serviceConfig.User = "gitolite";
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;

      path = [ pkgs.gitolite pkgs.git pkgs.perl pkgs.bash pkgs.openssh ];
      script = ''
        cd /var/lib/gitolite
        mkdir -p .gitolite/logs
        if [ ! -d repositories ]; then
          gitolite setup -pk ${pubkeyFile}
        fi
        gitolite setup # Upgrade if needed
      '';
    };

    environment.systemPackages = [ pkgs.gitolite pkgs.git ];
  };
}
