{config, pkgs, ...}:

let

  inherit (pkgs.lib) mkOption mergeListOption;
  
  makeJob = job:
    if job ? jobDrv then
      job.jobDrv
    else
      pkgs.runCommand ("upstart-" + job.name)
        { inherit (job) job;
          jobName = job.name;
          buildHook = if job ? buildHook then job.buildHook else "true";
        }
        ''
          eval "$buildHook"
          ensureDir $out/etc/event.d
          echo "$job" > $out/etc/event.d/$jobName
        '';

  jobs = map makeJob (config.jobs ++ config.services.extraJobs);
  
  # Create an etc/event.d directory containing symlinks to the
  # specified list of Upstart job files.
  jobsDir = pkgs.runCommand "upstart-jobs" {inherit jobs;}
    ''
      ensureDir $out/etc/event.d
      for i in $jobs; do
        if ln -s $i . ; then
          if test -d $i; then
            ln -s $i/etc/event.d/* $out/etc/event.d/
          fi
        else
          echo Duplicate entry: $i;
        fi;
      done
    ''; # */

in
  
{

  ###### interface
  
  options = {
  
    jobs = mkOption {
      default = [];
      example =
        [ { name = "test-job";
            job = ''
              description "nc"
              start on started network-interfaces
              respawn
              env PATH=/var/run/current-system/sw/bin
              exec sh -c "echo 'hello world' | ${pkgs.netcat}/bin/nc -l -p 9000"
             '';
          }
        ];
      # should have some checks to verify the syntax
      merge = pkgs.lib.mergeListOption;
      description = ''
        This option defines the system jobs started and managed by the
        Upstart daemon.
      '';
    };

    services.extraJobs = mkOption {
      default = [];
      merge = pkgs.lib.mergeListOption;
      description = ''
        Obsolete - don't use.
      '';
    };

    tests.upstartJobs = mkOption {
      internal = true;
      default = {};
      description = ''
        Make it easier to build individual Upstart jobs. (e.g.,
        <command>nix-build /etc/nixos/nixos -A
        tests.upstartJobs.xserver</command>).
      '';
    };
    
  };


  ###### implementation
  
  config = {

    environment.etc =
      [ { # The Upstart events defined above.
          source = "${jobsDir}/etc/event.d";
          target = "event.d";
        }
      ];

    services.extraJobs =
      [ # For the built-in logd job.
        { jobDrv = pkgs.upstart; }
      ];

    # see test/test-upstart-job.sh (!!! check whether this still works)
    tests.upstartJobs = { recurseForDerivations = true; } //
      builtins.listToAttrs (map (job:
        { name = if job ? jobName then job.jobName else job.name; value = job; }
      ) jobs);
  
  };

}
