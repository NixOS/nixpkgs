{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.preload;
  settingsFormat = pkgs.formats.ini {};
  configFile = settingsFormat.generate "preload.conf" cfg.settings;
in {
  options = {
    programs.preload = {
      enable = mkEnableOption "Preload loads files and executables to memory to speed up processes";
      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
        };
        apply = recursiveUpdate default;

        default = {
          model = {
            cycle = 20;
            usecorrelation = "true";
            minsize = 2000000;
            memtotal = -10;
            memfree = 50;
            memcached = 0;
          };
          system = {
            doscan = "true";
            dopredict = "true";
            autosave = 3600;
            mapprefix = "/run/current-system/sw/share;/run/current-system/sw/lib;!/";
            exeprefix = "!/run/current-system/sw/sbin/;/run/current-system/sw/bin;!/";
            processes = 30;
            sortstrategy = 3;
          };
        };
        description = ''
          Configuration for preload
        '';
        example = literalExpression ''
          {
            model = {
              # This is the quantum of time for preload.  Preload performs
              # data gathering and predictions every cycle.  Use an even
              # number.

              # Note: Setting this parameter too low may reduce system performance
              # and stability.

              # unit: seconds.
              cycle = 20;

              # Whether correlation coefficient should be used in the prediction
              # algorithm.  There are arguments both for and against using it.
              # Currently it's believed that using it results in more accurate
              # prediction.  The option may be removed in the future.
              usecorrelation = "true";

              # Minimum sum of the length of maps of the process for
              # preload to consider tracking the application.

              # Note: Setting this parameter too high will make preload less
              # effective, while setting it too low will make it eat
              # quadratically more resources, as it tracks more processes.

              # unit: bytes.
              minsize = "2000000";

              # Precentage of total memory
              memtotal = "-10";

              # Precentage of free memory
              memfree = "50";

              # Precentage of cached memory
              memcached = "0";
            };
            system = {
              # Whether preload should monitor running processes and update its
              # model state.  Normally you do want that, that's all preload is
              # about, but you may want to temporarily turn it off for various
              # reasons like testing and only make predictions.  Note that if
              # scanning is off, predictions are made based on whatever processes
              # have been running when preload started and the list of running
              # processes is not updated at all.
              doscan = "true";

              # Whether preload should make prediction and prefetch anything off
              # the disk.  Quite like doscan, you normally want that, that's the
              # other half of what preload is about, but you may want to temporarily
              # turn it off, to only train the model for example.  Note that
              # this allows you to turn scan/predict or or off on the fly, by
              # modifying the config file and signalling the daemon.
              dopredict = "true";

              # Preload will automatically save the state to disk every
              # autosave period.  This is only relevant if doscan is set to true.
              # Note that some janitory work on the model, like removing entries
              # for files that no longer exist happen at state save time.  So,
              # turning off autosave completely is not advised.

              # unit: seconds.
              autosave = "3600";

              # A list of path prefixes that control which mapped file are to
              # be considered by preload and which not.  The list items are
              # separated by semicolons.  Matching will be stopped as soon as
              # the first item is matched.  For each item, if item appears at
              # the beginning of the path of the file, then a match occurs, and
              # the file is accepted.  If on the other hand, the item has a
              # exclamation mark as its first character, then the rest of the
              # item is considered, and if a match happens, the file is rejected.
              # For example a value of !/lib/modules;/ means that every file other
              # than those in /lib/modules should be accepted.  In this case, the
              # trailing item can be removed, since if no match occurs, the file is
              # accepted.  It's advised to make sure /dev is rejected, since
              # preload doesn't special-handle device files internally.

              # Note that /lib matches all of /lib, /lib64, and even /libexec if
              # there was one.  If one really meant /lib only, they should use
              # /lib/ instead.
              mapprefix = "/usr/;/lib;/var/cache/;!/";

              # The syntax for this is exactly the same as for mapprefix.  The only
              # difference is that this is used to accept or reject binary exectuable
              # files instead of maps.
              exeprefix = "!/usr/sbin/;!/usr/local/sbin/;/usr/;!/";

              # Maximum number of processes to use to do parallel readahead.  If
              # equal to 0, no parallel processing is done and all readahead is
              # done in-process.  Parallel readahead supposedly gives a better I/O
              # performance as it allows the kernel to batch several I/O requests
              # of nearby blocks.
              processes = "30";

              # The I/O sorting strategy.  Ideally this should be automatically
              # decided, but it's not currently.  One of

              #  0 -- SORT_NONE:  No I/O sorting.
              #    Useful on Flash memory for example.
              #  1 -- SORT_PATH:  Sort based on file path only.
              #    Useful for network filesystems.
              #  2 -- SORT_INODE:  Sort based on inode number.
              #    Does less house-keeping I/O than the next option.
              #  3 -- SORT_BLOCK:  Sort I/O based on disk block.  Most sophisticated.
              #    And useful for most Linux filesystems.
              sortstrategy = "3";
            };
          };
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      services.preload = {
        description = "Adaptive readahead daemon";
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.preload}/bin/preload --foreground --verbose 1 -c ${configFile}";
          StateDirectory = "preload";
          LogsDirectory = "preload";
          IOSchedulingClass = 3;
        };
      };
    };
  };
}
