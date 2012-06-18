{ config, pkgs, ... }:

with pkgs.lib;

let

  upstart = pkgs.upstart;

  userExists = u:
    (u == "") || any (uu: uu.name == u) (attrValues config.users.extraUsers);

  groupExists = g:
    (g == "") || any (gg: gg.name == g) (attrValues config.users.extraGroups);

  # From a job description, generate an systemd unit file.
  makeUnit = job:

    let
      hasMain = job.script != "" || job.exec != "";

      env = config.system.upstartEnvironment // job.environment;

      preStartScript = pkgs.writeScript "${job.name}-pre-start.sh"
        ''
          #! ${pkgs.stdenv.shell} -e
          ${job.preStart}
        '';

      startScript = pkgs.writeScript "${job.name}-start.sh"
        ''
          #! ${pkgs.stdenv.shell} -e
          ${if job.script != "" then job.script else ''
            exec ${job.exec}
          ''}
        '';

      postStartScript = pkgs.writeScript "${job.name}-post-start.sh"
        ''
          #! ${pkgs.stdenv.shell} -e
          ${job.postStart}
        '';

      preStopScript = pkgs.writeScript "${job.name}-pre-stop.sh"
        ''
          #! ${pkgs.stdenv.shell} -e
          ${job.preStop}
        '';

      postStopScript = pkgs.writeScript "${job.name}-post-stop.sh"
        ''
          #! ${pkgs.stdenv.shell} -e
          ${job.postStop}
        '';
    in {

      text =
        ''
          [Unit]
          Description=${job.description}
          ${if job.startOn == "stopped udevtrigger" then "After=systemd-udev-settle.service" else
            if job.startOn == "started udev" then "After=systemd-udev.service"
            else ""}

          [Service]
          Environment=PATH=${job.path}
          ${concatMapStrings (n: "Environment=${n}=\"${getAttr n env}\"\n") (attrNames env)}

          ${optionalString (job.preStart != "" && (job.script != "" || job.exec != "")) ''
            ExecStartPre=${preStartScript}
          ''}

          ${optionalString (job.preStart != "" && job.script == "" && job.exec == "") ''
            ExecStart=${preStartScript}
          ''}

          ${optionalString (job.script != "" || job.exec != "") ''
            ExecStart=${startScript}
          ''}
          
          ${optionalString (job.postStart != "") ''
            ExecStartPost=${postStartScript}
          ''}

          ${optionalString (job.preStop != "") ''
            ExecStop=${preStopScript}
          ''}
          
          ${optionalString (job.postStop != "") ''
            ExecStopPost=${postStopScript}
          ''}

          ${if job.script == "" && job.exec == "" then "Type=oneshot\nRemainAfterExit=true" else
            if job.daemonType == "fork" then "Type=forking\nGuessMainPID=true" else
            if job.daemonType == "none" then "" else
            throw "invalid daemon type `${job.daemonType}'"}

          ${optionalString (!job.task && job.respawn) "Restart=always"}
        '';

      wantedBy = if job.startOn == "" then [ ] else [ "multi-user.target" ];

    };

      /*
      text =
        ''
          ${optionalString (job.description != "") ''
            description "${job.description}"
          ''}

          ${if isList job.startOn then
              "start on ${concatStringsSep " or " job.startOn}"
            else if job.startOn != "" then
              "start on ${job.startOn}"
            else ""
          }

          ${optionalString (job.stopOn != "") "stop on ${job.stopOn}"}

          env PATH=${job.path}

          ${concatMapStrings (n: "env ${n}=\"${getAttr n env}\"\n") (attrNames env)}

          ${optionalString (job.console != "") "console ${job.console}"}

          pre-start script
            ln -sfn "$(readlink -f "/etc/init/${job.name}.conf")" /var/run/upstart-jobs/${job.name}
            ${optionalString (job.preStart != "") ''
              source ${jobHelpers}
              ${job.preStart}
            ''}
          end script

          ${if job.script != "" && job.exec != "" then
              abort "Job ${job.name} has both a `script' and `exec' attribute."
            else if job.script != "" then
              ''
                script
                  source ${jobHelpers}
                  ${job.script}
                end script
              ''
            else if job.exec != "" && job.console == "" then
              ''
                script
                  exec ${job.exec}
                end script
              ''
            else if job.exec != "" then
              ''
                exec ${job.exec}
              ''
            else ""
          }

          ${optionalString (job.postStart != "") ''
            post-start script
              source ${jobHelpers}
              ${job.postStart}
            end script
          ''}

          ${optionalString job.task "task"}
          ${optionalString (!job.task && job.respawn) "respawn"}

          ${ # preStop is run only if there is exec or script.
             # (upstart 0.6.5, job.c:562)
            optionalString (job.preStop != "") (assert hasMain; ''
            pre-stop script
              source ${jobHelpers}
              ${job.preStop}
            end script
          '')}

          ${optionalString (job.postStop != "") ''
            post-stop script
              source ${jobHelpers}
              ${job.postStop}
            end script
          ''}

          ${if job.daemonType == "fork" then "expect fork" else
            if job.daemonType == "daemon" then "expect daemon" else
            if job.daemonType == "stop" then "expect stop" else
            if job.daemonType == "none" then "" else
            throw "invalid daemon type `${job.daemonType}'"}

          ${optionalString (job.setuid != "") ''
            setuid ${job.setuid}
          ''}

          ${optionalString (job.setgid != "") ''
            setuid ${job.setgid}
          ''}

          ${job.extraConfig}
        '';
      */


  # Shell functions for use in Upstart jobs.
  jobHelpers = pkgs.writeText "job-helpers.sh"
    ''
      # Ensure that an Upstart service is running.
      ensure() {
          local job="$1"
          local status="$(status "$job")"

          # If it's already running, we're happy.
          [[ "$status" =~ start/running ]] && return 0

          # If its current goal is to stop, start it.
          [[ "$status" =~ stop/ ]] && { status="$(start "$job")" || true; }

          # The "start" command is synchronous *if* the job is
          # not already starting.  So if somebody else started
          # the job in parallel, the "start" above may return
          # while the job is still starting.  So wait until it
          # is up or has failed.
          while true; do
              [[ "$status" =~ stop/ ]] && { echo "job $job failed to start"; return 1; }
              [[ "$status" =~ start/running ]] && return 0
              echo "waiting for job $job to start..."
              sleep 1
              status="$(status "$job")"
          done
      }

      # Check whether the current job has been stopped.  Used in
      # post-start jobs to determine if they should continue.
      stop_check() {
          local status="$(status)"
          if [[ "$status" =~ stop/ ]]; then
              echo "job asked to stop!"
              return 1
          fi
          if [[ "$status" =~ respawn/ ]]; then
              echo "job respawning unexpectedly!"
              stop
              return 1
          fi
          return 0
      }
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

    description = mkOption {
      type = types.string;
      default = "";
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

    restartIfChanged = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether the job should be restarted if it has changed after a
        NixOS configuration switch.
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

    setuid = mkOption {
      type = types.string;
      check = userExists;
      default = "";
      description = ''
        Run the daemon as a different user.
      '';
    };

    setgid = mkOption {
      type = types.string;
      check = groupExists;
      default = "";
      description = ''
        Run the daemon as a different group.
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
      apply = ps: "${makeSearchPath "bin" ps}:${makeSearchPath "sbin" ps}";
      description = ''
        Packages added to the job's <envar>PATH</envar> environment variable.
        Both the <filename>bin</filename> and <filename>sbin</filename>
        subdirectories of each package are added.
      '';
    };

    console = mkOption {
      default = "";
      example = "console";
      description = ''
        If set to <literal>output</literal>, job output is written to
        the console.  If it's <literal>owner</literal>, additionally
        the job becomes owner of the console.  It it's empty (the
        default), output is written to
        <filename>/var/log/upstart/<replaceable>jobname</replaceable></filename>
      '';  
    };

  };


  upstartJob = {name, config, ...}: {

    options = {
    
      unit = mkOption {
        default = makeUnit config;
        description = "Generated definition of the systemd unit corresponding to this job.";
      };
      
    };

    config = {
    
      # The default name is the name extracted from the attribute path.
      name = mkDefaultValue name;
      
      # Default path for Upstart jobs.  Should be quite minimal.
      path =
        [ pkgs.coreutils
          pkgs.findutils
          pkgs.gnugrep
          pkgs.gnused
          upstart
        ];
      
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
      type = types.loaOf types.optionSet;
      options = [ jobOptions upstartJob ];
    };

    system.upstartEnvironment = mkOption {
      type = types.attrs;
      default = {};
      example = { TZ = "CET"; };
      description = ''
        Environment variables passed to <emphasis>all</emphasis> Upstart jobs.
      '';
    };

  };


  ###### implementation

  config = {

    system.build.upstart = upstart;

    boot.systemd.units =
      flip mapAttrs' config.jobs (name: job:
        nameValuePair "${job.name}.service" job.unit);
        
  };

}
