{config, pkgs, ...}:

with pkgs.lib;

let

  # From a job description, generate an Upstart job file.
  makeJob = job@{buildHook ? "", ...}:

    let

      jobText = if job.job != "" then job.job else
        ''
          description "${job.description}"

          ${if job.startOn != "" then "start on ${job.startOn}" else ""}
          ${if job.stopOn != "" then "start on ${job.stopOn}" else ""}

          ${concatMapStrings (n: "env ${n}=${getAttr n job.environment}\n") (attrNames job.environment)}
          
          ${if job.preStart != "" then ''
            start script
              ${job.preStart}
            end script
          '' else ""}
          
          ${if job.exec != "" then ''
            exec ${job.exec}
          '' else ""}

          ${if job.respawn then "respawn" else ""}
        '';

    in
      pkgs.runCommand ("upstart-" + job.name)
        { inherit buildHook; inherit jobText; }
        ''
          eval "$buildHook"
          ensureDir $out/etc/event.d
          echo "$jobText" > $out/etc/event.d/${job.name}
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
          default = "";
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

        description = mkOption {
          type = types.string;
          default = "(no description given)";
          description = ''
            A short description of this job.
          '';
        };

        startOn = mkOption {
          type = types.string;
          default = "";
          description = ''
            The Upstart event that triggers this job to be started.
            If empty, the job will not start automatically.
          '';
        };

        stopOn = mkOption {
          type = types.string;
          default = "";
          description = ''
            The Upstart event that triggers this job to be stopped.
          '';
        };

        preStart = mkOption {
          type = types.string;
          default = "";
          description = ''
            Shell commands executed before the job is started
            (i.e. before the <varname>exec</varname> command is run).
          '';
        };

        exec = mkOption {
          type = types.string;
          default = "";
          description = ''
            Command to start the job.
          '';
        };

        respawn = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to restart the job automatically if its process
            ends unexpectedly.
          '';
        };

        environment = mkOption {
          type = types.attrs;
          default = {};
          example = { PATH = "/foo/bar/bin"; LANG = "nl_NL.UTF-8"; };
          description = ''
            Environment variables passed to the job's processes.
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
