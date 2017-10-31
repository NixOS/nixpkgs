{ config, lib, pkgs, ... }:

with lib;

let
  jenkinsCfg = config.services.jenkins;
  cfg = config.services.jenkins.jobBuilder;

in {
  options = {
    services.jenkins.jobBuilder = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not to enable the Jenkins Job Builder (JJB) service. It
          allows defining jobs for Jenkins in a declarative manner.

          Jobs managed through the Jenkins WebUI (or by other means) are left
          unchanged.

          Note that it really is declarative configuration; if you remove a
          previously defined job, the corresponding job directory will be
          deleted.

          Please see the Jenkins Job Builder documentation for more info:
          <link xlink:href="http://docs.openstack.org/infra/jenkins-job-builder/">
          http://docs.openstack.org/infra/jenkins-job-builder/</link>
        '';
      };

      accessUser = mkOption {
        default = "";
        type = types.str;
        description = ''
          User id in Jenkins used to reload config.
        '';
      };

      accessToken = mkOption {
        default = "";
        type = types.str;
        description = ''
          User token in Jenkins used to reload config.
        '';
      };

      yamlJobs = mkOption {
        default = "";
        type = types.lines;
        example = ''
          - job:
              name: jenkins-job-test-1
              builders:
                - shell: echo 'Hello world!'
        '';
        description = ''
          Job descriptions for Jenkins Job Builder in YAML format.
        '';
      };

      jsonJobs = mkOption {
        default = [ ];
        type = types.listOf types.str;
        example = literalExample ''
          [
            '''
              [ { "job":
                  { "name": "jenkins-job-test-2",
                    "builders": [ "shell": "echo 'Hello world!'" ]
                  }
                }
              ]
            '''
          ]
        '';
        description = ''
          Job descriptions for Jenkins Job Builder in JSON format.
        '';
      };

      nixJobs = mkOption {
        default = [ ];
        type = types.listOf types.attrs;
        example = literalExample ''
          [ { job =
              { name = "jenkins-job-test-3";
                builders = [
                  { shell = "echo 'Hello world!'"; }
                ];
              };
            }
          ]
        '';
        description = ''
          Job descriptions for Jenkins Job Builder in Nix format.

          This is a trivial wrapper around jsonJobs, using builtins.toJSON
          behind the scene.
        '';
      };
    };
  };

  config = mkIf (jenkinsCfg.enable && cfg.enable) {
    systemd.services.jenkins-job-builder = {
      description = "Jenkins Job Builder Service";
      # JJB can run either before or after jenkins. We chose after, so we can
      # always use curl to notify (running) jenkins to reload its config.
      after = [ "jenkins.service" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [ jenkins-job-builder curl ];

      # Q: Why manipulate files directly instead of using "jenkins-jobs upload [...]"?
      # A: Because this module is for administering a local jenkins install,
      #    and using local file copy allows us to not worry about
      #    authentication.
      script =
        let
          yamlJobsFile = builtins.toFile "jobs.yaml" cfg.yamlJobs;
          jsonJobsFiles =
            map (x: (builtins.toFile "jobs.json" x))
              (cfg.jsonJobs ++ [(builtins.toJSON cfg.nixJobs)]);
          jobBuilderOutputDir = "/run/jenkins-job-builder/output";
          # Stamp file is placed in $JENKINS_HOME/jobs/$JOB_NAME/ to indicate
          # ownership. Enables tracking and removal of stale jobs.
          ownerStamp = ".config-xml-managed-by-nixos-jenkins-job-builder";
          reloadScript = ''
            echo "Asking Jenkins to reload config"
            CRUMB=$(curl -s 'http://${cfg.accessUser}:${cfg.accessToken}@${jenkinsCfg.listenAddress}:${toString jenkinsCfg.port}${jenkinsCfg.prefix}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
            curl --silent -X POST -H "$CRUMB" http://${cfg.accessUser}:${cfg.accessToken}@${jenkinsCfg.listenAddress}:${toString jenkinsCfg.port}${jenkinsCfg.prefix}/reload
          '';
        in
          ''
            rm -rf ${jobBuilderOutputDir}
            cur_decl_jobs=/run/jenkins-job-builder/declarative-jobs
            rm -f "$cur_decl_jobs"

            # Create / update jobs
            mkdir -p ${jobBuilderOutputDir}
            for inputFile in ${yamlJobsFile} ${concatStringsSep " " jsonJobsFiles}; do
                HOME="${jenkinsCfg.home}" "${pkgs.jenkins-job-builder}/bin/jenkins-jobs" --ignore-cache test -o "${jobBuilderOutputDir}" "$inputFile"
            done

            for file in "${jobBuilderOutputDir}/"*; do
                test -f "$file" || continue
                jobname="$(basename $file)"
                jobdir="${jenkinsCfg.home}/jobs/$jobname"
                echo "Creating / updating job \"$jobname\""
                mkdir -p "$jobdir"
                touch "$jobdir/${ownerStamp}"
                cp "$file" "$jobdir/config.xml"
                echo "$jobname" >> "$cur_decl_jobs"
            done

            # Remove stale jobs
            for file in "${jenkinsCfg.home}"/jobs/*/${ownerStamp}; do
                test -f "$file" || continue
                jobdir="$(dirname $file)"
                jobname="$(basename "$jobdir")"
                grep --quiet --line-regexp "$jobname" "$cur_decl_jobs" 2>/dev/null && continue
                echo "Deleting stale job \"$jobname\""
                rm -rf "$jobdir"
            done
          '' + (if cfg.accessUser != "" then reloadScript else "");
      serviceConfig = {
        User = jenkinsCfg.user;
        RuntimeDirectory = "jenkins-job-builder";
      };
    };
  };
}
