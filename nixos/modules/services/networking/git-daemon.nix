{pkgs, config, ...}:
with pkgs.lib;
let

  cfg = config.services.gitDaemon;
  gitUser = "git";

in
{

  ###### interface

  options = {
    services.gitDaemon = {

      enable = mkOption {
        default = false;
        description = ''
          Enable Git daemon, which allows public hosting  of git repositories
          without any access controls. This is mostly intended for read-only access.

          You can allow write access by setting daemon.receivepack configuration
          item of the repository to true. This is solely meant for a closed LAN setting
          where everybody is friendly.

          If you need any access controls, use something else.
        '';
      };

      basePath = mkOption {
        default = "";
        example = "/srv/git/";
        description = ''
          Remap all the path requests as relative to the given path. For example,
          if you set base-path to /srv/git, then if you later try to pull
          git://example.com/hello.git, Git daemon will interpret the path as /srv/git/hello.git.
        '';
      };

      exportAll = mkOption {
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
        default = "";
        example = "example.com";
        description = "Listen on a specific IP address or hostname.";
      };

      port = mkOption {
        default = 9418;
        description = "Port to listen on.";
      };

      options = mkOption {
        default = "";
        description = "Extra configuration options to be passed to Git daemon.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = gitUser;
        uid = config.ids.uids.git;
        description = "Git daemon user";
      };

    users.extraGroups = singleton
      { name = gitUser;
        gid = config.ids.gids.git;
      };

    jobs.gitDaemon = {
      name = "git-daemon";
      startOn = "ip-up";
      exec = "${pkgs.git}/bin/git daemon --reuseaddr "
        + (optionalString (cfg.basePath != "") "--base-path=${cfg.basePath} ")
        + (optionalString (cfg.listenAddress != "") "--listen=${cfg.listenAddress} ")
        + "--port=${toString cfg.port} --user=${gitUser} --group=${gitUser} ${cfg.options} "
        + "--verbose " + (optionalString cfg.exportAll "--export-all")  + concatStringsSep " " cfg.repositories;
    };

  };

}
