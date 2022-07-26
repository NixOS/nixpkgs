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
          WARNING: This token will be world readable in the Nix store. To keep
          it secret, use the <option>accessTokenFile</option> option instead.
        '';
      };

      accessTokenFile = mkOption {
        default = "";
        type = types.str;
        example = "/run/keys/jenkins-job-builder-access-token";
        description = ''
          File containing the API token for the <option>accessUser</option>
          user.
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
        example = literalExpression ''
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
        example = literalExpression ''
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
    assertions = [
      { assertion =
          if cfg.accessUser != ""
          then (cfg.accessToken != "" && cfg.accessTokenFile == "") ||
               (cfg.accessToken == "" && cfg.accessTokenFile != "")
          else true;
        message = ''
          One of accessToken and accessTokenFile options must be non-empty
          strings, but not both. Current values:
            services.jenkins.jobBuilder.accessToken = "${cfg.accessToken}"
            services.jenkins.jobBuilder.accessTokenFile = "${cfg.accessTokenFile}"
        '';
      }
    ];

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
            curl_opts="--silent --fail --show-error"
            access_token_file=${if cfg.accessTokenFile != ""
                           then cfg.accessTokenFile
                           else "$RUNTIME_DIRECTORY/jenkins_access_token.txt"}
            if [ "${cfg.accessToken}" != "" ]; then
               (umask 0077; printf "${cfg.accessToken}" >"$access_token_file")
            fi
            jenkins_url="http://${jenkinsCfg.listenAddress}:${toString jenkinsCfg.port}${jenkinsCfg.prefix}"
            auth_file="$RUNTIME_DIRECTORY/jenkins_auth_file.txt"
            trap 'rm -f "$auth_file"' EXIT
            (umask 0077; printf "${cfg.accessUser}:@password_placeholder@" >"$auth_file")
            "${pkgs.replace-secret}/bin/replace-secret" "@password_placeholder@" "$access_token_file" "$auth_file"

            if ! "${pkgs.jenkins}/bin/jenkins-cli" -s "$jenkins_url" -auth "@$auth_file" reload-configuration; then
                echo "error: failed to reload configuration"
                exit 1
            fi
          '';
        in
          ''
            joinByString()
            {
                local separator="$1"
                shift
                local first="$1"
                shift
                printf "%s" "$first" "''${@/#/$separator}"
            }

            # Map a relative directory path in the output from
            # jenkins-job-builder (jobname) to the layout expected by jenkins:
            # each directory level gets prepended "jobs/".
            getJenkinsJobDir()
            {
                IFS='/' read -ra input_dirs <<< "$1"
                printf "jobs/"
                joinByString "/jobs/" "''${input_dirs[@]}"
            }

            # The inverse of getJenkinsJobDir (remove the "jobs/" prefixes)
            getJobname()
            {
                IFS='/' read -ra input_dirs <<< "$1"
                local i=0
                local nelem=''${#input_dirs[@]}
                for e in "''${input_dirs[@]}"; do
                    if [ $((i % 2)) -eq 1 ]; then
                        printf "$e"
                        if [ $i -lt $(( nelem - 1 )) ]; then
                            printf "/"
                        fi
                    fi
                    i=$((i + 1))
                done
            }

            rm -rf ${jobBuilderOutputDir}
            cur_decl_jobs=/run/jenkins-job-builder/declarative-jobs
            rm -f "$cur_decl_jobs"

            # Create / update jobs
            mkdir -p ${jobBuilderOutputDir}
            for inputFile in ${yamlJobsFile} ${concatStringsSep " " jsonJobsFiles}; do
                HOME="${jenkinsCfg.home}" "${pkgs.jenkins-job-builder}/bin/jenkins-jobs" --ignore-cache test --config-xml -o "${jobBuilderOutputDir}" "$inputFile"
            done

            find "${jobBuilderOutputDir}" -type f -name config.xml | while read -r f; do echo "$(dirname "$f")"; done | sort | while read -r dir; do
                jobname="$(realpath --relative-to="${jobBuilderOutputDir}" "$dir")"
                jenkinsjobname=$(getJenkinsJobDir "$jobname")
                jenkinsjobdir="${jenkinsCfg.home}/$jenkinsjobname"
                echo "Creating / updating job \"$jobname\""
                mkdir -p "$jenkinsjobdir"
                touch "$jenkinsjobdir/${ownerStamp}"
                cp "$dir"/config.xml "$jenkinsjobdir/config.xml"
                echo "$jenkinsjobname" >> "$cur_decl_jobs"
            done

            # Remove stale jobs
            find "${jenkinsCfg.home}" -type f -name "${ownerStamp}" | while read -r f; do echo "$(dirname "$f")"; done | sort --reverse | while read -r dir; do
                jenkinsjobname="$(realpath --relative-to="${jenkinsCfg.home}" "$dir")"
                grep --quiet --line-regexp "$jenkinsjobname" "$cur_decl_jobs" 2>/dev/null && continue
                jobname=$(getJobname "$jenkinsjobname")
                echo "Deleting stale job \"$jobname\""
                jobdir="${jenkinsCfg.home}/$jenkinsjobname"
                rm -rf "$jobdir"
            done
          '' + (if cfg.accessUser != "" then reloadScript else "");
      serviceConfig = {
        Type = "oneshot";
        User = jenkinsCfg.user;
        RuntimeDirectory = "jenkins-job-builder";
      };
    };
  };
}
