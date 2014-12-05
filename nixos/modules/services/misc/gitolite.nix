{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitolite;
  pubkeyFile = pkgs.writeText "gitolite-admin.pub" cfg.adminPubkey;
  hooks = lib.concatMapStrings (hook: "${hook} ") cfg.commonHooks;
in
{
  options = {
    services.gitolite = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable gitolite management under the
          <literal>gitolite</literal> user. After
          switching to a configuration with Gitolite enabled, you can
          then run <literal>git clone
          gitolite@host:gitolite-admin.git</literal> to manage it further.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/gitolite";
        description = ''
          Gitolite home directory (used to store all the repositories).
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

      commonHooks = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
          A list of custom git hooks that get copied to <literal>~/.gitolite/hooks/common</literal>.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "gitolite";
        description = ''
          Gitolite user account. This is the username of the gitolite endpoint.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.${cfg.user} = {
      description     = "Gitolite user";
      home            = cfg.dataDir;
      createHome      = true;
      uid             = config.ids.uids.gitolite;
      useDefaultShell = true;
    };

    systemd.services."gitolite-init" = {
      description = "Gitolite initialization";
      wantedBy    = [ "multi-user.target" ];

      serviceConfig.User = "${cfg.user}";
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;

      path = [ pkgs.gitolite pkgs.git pkgs.perl pkgs.bash pkgs.openssh ];
      script = ''
        cd ${cfg.dataDir}
        mkdir -p .gitolite/logs
        if [ ! -d repositories ]; then
          gitolite setup -pk ${pubkeyFile}
        fi
        if [ -n "${hooks}" ]; then
          cp ${hooks} .gitolite/hooks/common/
          chmod +x .gitolite/hooks/common/*
        fi
        gitolite setup # Upgrade if needed
      '';
    };

    environment.systemPackages = [ pkgs.gitolite pkgs.git ];
  };
}
