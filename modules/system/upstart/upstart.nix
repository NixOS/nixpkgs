{config, pkgs, ...}:

let

  inherit (pkgs.lib) mkOption mergeListOption types;
  
  makeJob =
    {name, job, buildHook ? "true", passthru ? null}:
    
    pkgs.runCommand ("upstart-" + name)
      { inherit buildHook job; }
      ''
        eval "$buildHook"
        ensureDir $out/etc/event.d
        echo "$job" > $out/etc/event.d/${name}
      '';

  jobs =
    [pkgs.upstart] # for the built-in logd job
    ++ map makeJob (config.jobs ++ config.services.extraJobs);
  
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
      description = ''
        This option defines the system jobs started and managed by the
        Upstart daemon.
      '';

      type = types.list types.optionSet;

      options = {

        name = mkOption {
          type = types.string;
          example = "sshd";
          description = ''
            Name of the Upstart job.
          '';
        };

        job = mkOption {
          type = types.string;
          example =
            ''
              description "nc"
              start on started network-interfaces
              respawn
              env PATH=/var/run/current-system/sw/bin
              exec sh -c "echo 'hello world' | ${pkgs.netcat}/bin/nc -l -p 9000"
            '';
          description = ''
            Contents of the Upstart job.
          '';
        };

        buildHook = mkOption {
          type = types.string;
          default = "true";
          description = ''
            Command run while building the Upstart job.  Can be used
            to perform simple regression tests (e.g., the Apache
            Upstart job uses it to check the syntax of the generated
            <filename>httpd.conf</filename>.
          '';
        };

      };
      
    };

    services.extraJobs = mkOption {
      default = [];
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

    # see test/test-upstart-job.sh (!!! check whether this still works)
    tests.upstartJobs = { recurseForDerivations = true; } //
      builtins.listToAttrs (map (job:
        { name = if job ? jobName then job.jobName else job.name; value = job; }
      ) jobs);
  
  };

}
