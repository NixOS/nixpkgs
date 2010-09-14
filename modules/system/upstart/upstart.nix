{config, pkgs, ...}:

with pkgs.lib;

let

  upstart = pkgs.upstart;


  # Path for Upstart jobs.  Should be quite minimal.
  upstartPath =
    [ pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
      upstart
    ];

    
  # From a job description, generate an Upstart job file.
  makeJob = job:

    let
      hasMain = job.script != "" || job.exec != "";

      jobText =
        let log = "/var/log/upstart/${job.name}"; in
        ''
          # Upstart job `${job.name}'.  This is a generated file.  Do not edit.
        
          description "${job.description}"

          ${if isList job.startOn then
              "start on ${concatStringsSep " or " job.startOn}"
            else if job.startOn != "" then
              "start on ${job.startOn}"
            else ""
          }
          
          ${optionalString (job.stopOn != "") "stop on ${job.stopOn}"}

          env PATH=${makeSearchPath "bin" (job.path ++ upstartPath)}:${makeSearchPath "sbin" (job.path ++ upstartPath)}

          ${concatMapStrings (n: "env ${n}=\"${getAttr n job.environment}\"\n") (attrNames job.environment)}
          
          ${optionalString (job.preStart != "") ''
            pre-start script
              exec >> ${log} 2>&1
              ${job.preStart}
            end script
          ''}
          
          ${if job.script != "" && job.exec != "" then
              abort "Job ${job.name} has both a `script' and `exec' attribute."
            else if job.script != "" then
              ''
                script
                  exec >> ${log} 2>&1
                  ${job.script}
                end script
              ''
            else if job.exec != "" then
              ''
                script
                  exec >> ${log} 2>&1
                  exec ${job.exec}
                end script
              ''
            else ""
          }

          ${optionalString (job.postStart != "") ''
            post-start script
              exec >> ${log} 2>&1
              ${job.postStart}
            end script
          ''}
          
          ${optionalString job.task "task"}
          ${optionalString (!job.task && job.respawn) "respawn"}

          ${ # preStop is run only if there is exec or script.
             # (upstart 0.6.5, job.c:562)
            optionalString (job.preStop != "") (assert hasMain; ''
            pre-stop script
              exec >> ${log} 2>&1
              ${job.preStop}
            end script
          '')}

          ${optionalString (job.postStop != "") ''
            post-stop script
              exec >> ${log} 2>&1
              ${job.postStop}
            end script
          ''}

          ${optionalString (!job.task) (
             if job.daemonType == "fork" then "expect fork" else
             if job.daemonType == "daemon" then "expect daemon" else
             if job.daemonType == "stop" then "expect stop" else
             if job.daemonType == "none" then "" else
             throw "invalid daemon type `${job.daemonType}'"
          )}

          ${job.extraConfig}
        '';

    in
      pkgs.runCommand ("upstart-" + job.name + ".conf")
        { inherit (job) buildHook; inherit jobText; }
        ''
          eval "$buildHook"
          echo "$jobText" > $out
        '';

        
  jobOptions = {

    name = mkOption {
      # !!! The type should ensure that this could be a filename.
      type = types.string;
      example = "sshd";
      description = ''
        Name of the Upstart job.
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
      # !!! Re-enable this once we're on Upstart >= 0.6.
      #type = types.string; 
      default = "";
      description = ''
        The Upstart event that triggers this job to be started.
        If empty, the job will not start automatically.
      '';
    };

    stopOn = mkOption {
      type = types.string;
      default = "starting shutdown";
      description = ''
        The Upstart event that triggers this job to be stopped.
      '';
    };

    preStart = mkOption {
      type = types.string;
      default = "";
      description = ''
        Shell commands executed before the job is started
        (i.e. before the job's main process is started).
      '';
    };

    postStart = mkOption {
      type = types.string;
      default = "";
      description = ''
        Shell commands executed after the job is started (i.e. after
        the job's main process is started), but before the job is
        considered “running”.
      '';
    };

    preStop = mkOption {
      type = types.string;
      default = "";
      description = ''
        Shell commands executed before the job is stopped
        (i.e. before Upstart kills the job's main process).  This can
        be used to cleanly shut down a daemon.
      '';
    };

    postStop = mkOption {
      type = types.string;
      default = "";
      description = ''
        Shell commands executed after the job has stopped
        (i.e. after the job's main process has terminated).
      '';
    };

    exec = mkOption {
      type = types.string;
      default = "";
      description = ''
        Command to start the job's main process.  If empty, the
        job has no main process, but can still have pre/post-start
        and pre/post-stop scripts, and is considered “running”
        until it is stopped.
      '';
    };

    script = mkOption {
      type = types.string;
      default = "";
      description = ''
        Shell commands executed as the job's main process.  Can be
        specified instead of the <varname>exec</varname> attribute.
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

    task = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether this job is a task rather than a service.  Tasks
        are executed only once, while services are restarted when
        they exit.
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

    daemonType = mkOption {
      type = types.string;
      default = "none";
      description = ''
        Determines how Upstart detects when a daemon should be
        considered “running”.  The value <literal>none</literal> means
        that the daemon is considered ready immediately.  The value
        <literal>fork</literal> means that the daemon will fork once.
        The value <literal>daemon</literal> means that the daemon will
        fork twice.  The value <literal>stop</literal> means that the
        daemon will raise the SIGSTOP signal to indicate readiness.
      '';
    };

    extraConfig = mkOption {
      type = types.string;
      default = "";
      example = "limit nofile 4096 4096";
      description = ''
        Additional Upstart stanzas not otherwise supported.
      '';
    };

    path = mkOption {
      default = [ ];
      description = ''
        Packages added to the job's <envar>PATH</envar> environment variable.
        Both the <filename>bin</filename> and <filename>sbin</filename> 
        subdirectories of each package are added.
      '';
    };

  };

  
  upstartJob = {name, config, ...}: {
  
    options = {
      jobDrv = mkOption {
        default = makeJob config;
        type = types.uniq types.package;
        description = ''
          Derivation that builds the Upstart job file.  The default
          value is generated from other options.
        '';
      };
    };

    config = {
      # The default name is the name extracted from the attribute path.
      name = mkDefaultValue (
        replaceChars ["<" ">" "*"] ["_" "_" "_name_"] name
      );
    };
    
  };

in
  
{

  ###### interface
  
  options = {

    jobs = mkOption {
      default = {};
      description = ''
        This option defines the system jobs started and managed by the
        Upstart daemon.
      '';
      type = types.attrsOf types.optionSet;
      options = [ jobOptions upstartJob ];
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

    system.build.upstart = upstart;

    environment.etc =
      flip map (attrValues config.jobs) (job:
        { source = job.jobDrv;
          target = "init/${job.name}.conf";
        } );

    # Upstart can listen on the system bus, allowing normal users to
    # do status queries.
    services.dbus.packages = [ upstart ];

  };

}
