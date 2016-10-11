{pkgs, config, lib, ...}:

let
  inherit (lib) optionalString concatStringsSep mkOption mkIf;
  cfg = config.services.cleanTmp;
in

{

  ###### interface

  options = {

    services.cleanTmp = {

      enable = mkOption {
        default = false;
        description = ''
          Enable the tmp file cleaning service
        '';
      };

      startAt = mkOption {
        default = "daily";
        description = ''
          A systemd.time(5) string for how often to run
        '';
      };

      time = mkOption {
        default = "7d";
        description = ''
          The threshold for removing files. If the file has not been accessed
          for time, the file is removed. The time argument is a number with an
          optional single-character suffix specifying the units: m for minutes,
          h for hours, d for days. If no suffix is specified, time is in hours.
        '';
      };

      dirs = mkOption {
        default = ["/tmp"];
        description = ''
          A list of directories to clean
        '';
      };

      mtime = mkOption {
        default = false;
        description = ''
          Make the decision about deleting a file based on the file's mtime
          (modification time) instead of the atime.
        '';
      };

      ctime = mkOption {
        default = false;
        description = ''
          Make the decision about deleting a file based on the file's ctime
          (inode change time) instead of the atime for directories, make the
          decision based on the mtime.
        '';
      };

      dirmtime = mkOption {
        default = false;
        description = ''
          Make the decision about deleting a directory based on the directory's
          mtime (modification time) instead of the atime; completely ignore
          atime for directories.
        '';
      };

      all = mkOption {
        default = false;
        description = ''
          Remove all file types, not just regular files, symbolic links and
          directories. On systems where tmpwatch can remove unused sockets, make
          the decision only based on file times, ignoring possible use of the
          socket.
        '';
      };

      nodirs = mkOption {
        default = false;
        description = ''
          Do not attempt to remove directories, even if they are empty.
        '';
      };

      force = mkOption {
        default = false;
        description = ''
          Remove root-owned files even if root doesn't have write access (akin
          to rm -f);
        '';
      };

      nosymlinks = mkOption {
        default = false;
        description = ''
          Do not attempt to remove symbolic links.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.cleanTmp.enable {

    systemd.services.cleantmp = {
      description = "Periodic tmp file cleaner";
      wantedBy = [ "multi-user.target" ];
      startAt = cfg.startAt;
      serviceConfig = {
        ExecStart = pkgs.writeScript "cleantmp" ''
          #!${pkgs.bash}/bin/bash

          ${pkgs.tmpwatch}/bin/tmpwatch \
            ${optionalString cfg.mtime "-m"} \
            ${optionalString cfg.ctime "-c"} \
            ${optionalString cfg.dirmtime "-M"} \
            ${optionalString cfg.all "-a"} \
            ${optionalString cfg.nodirs "-n"} \
            ${optionalString cfg.force "-f"} \
            ${optionalString cfg.nosymlinks "-l"} \
            ${cfg.time} ${concatStringsSep " " cfg.dirs}
        '';
      };
    };

  };

}
