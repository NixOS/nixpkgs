{ config, lib, pkgs, ... }:
with lib;
let

  cfg = config.services.gitDaemon;

in
{

  ###### interface

  options = {
    services.gitDaemon = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable Git daemon, which allows public hosting of git repositories
          without any access controls. This is mostly intended for read-only access.

          You can allow write access by setting daemon.receivepack configuration
          item of the repository to true. This is solely meant for a closed LAN setting
          where everybody is friendly.

          If you need any access controls, use something else.
        '';
      };

      basePath = mkOption {
        type = types.str;
        default = "";
        example = "/srv/git/";
        description = ''
          Remap all the path requests as relative to the given path. For example,
          if you set base-path to /srv/git, then if you later try to pull
          git://example.com/hello.git, Git daemon will interpret the path as /srv/git/hello.git.
        '';
      };

      exportAll = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Publish all directories that look like Git repositories (have the objects
          and refs subdirectories), even if they do not have the git-daemon-export-ok file.

          If disabled, you need to touch .git/git-daemon-export-ok in each repository
          you want the daemon to publish.

          Warning: enabling this without a repository whitelist or basePath
          publishes every git repository you have.
        '';
      };

      repositories = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "/srv/git" "/home/user/git/repo2" ];
        description = ''
          A whitelist of paths of git repositories, or directories containing repositories
          all of which would be published. Paths must not end in "/".

          Warning: leaving this empty and enabling exportAll publishes all
          repositories in your filesystem or basePath if specified.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "";
        example = "example.com";
        description = "Listen on a specific IP address or hostname.";
      };

      port = mkOption {
        type = types.int;
        default = 9418;
        description = "Port to listen on.";
      };

      options = mkOption {
        type = types.str;
        default = "";
        description = "Extra configuration options to be passed to Git daemon.";
      };

      user = mkOption {
        type = types.str;
        default = "git";
        description = "User under which Git daemon would be running.";
      };

      group = mkOption {
        type = types.str;
        default = "git";
        description = "Group under which Git daemon would be running.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = if cfg.user != "git" then {} else singleton
      { name = "git";
        uid = config.ids.uids.git;
        description = "Git daemon user";
      };

    users.extraGroups = if cfg.group != "git" then {} else singleton
      { name = "git";
        gid = config.ids.gids.git;
      };

    systemd.services."git-daemon" = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = "${pkgs.git}/bin/git daemon --reuseaddr "
        + (optionalString (cfg.basePath != "") "--base-path=${cfg.basePath} ")
        + (optionalString (cfg.listenAddress != "") "--listen=${cfg.listenAddress} ")
        + "--port=${toString cfg.port} --user=${cfg.user} --group=${cfg.group} ${cfg.options} "
        + "--verbose " + (optionalString cfg.exportAll "--export-all ")  + concatStringsSep " " cfg.repositories;
    };

  };

}
