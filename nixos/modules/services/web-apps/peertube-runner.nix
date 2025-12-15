{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.peertube-runner;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "config.toml" cfg.settings;

  env = {
    NODE_ENV = "production";
    XDG_CONFIG_HOME = "/var/lib/peertube-runner";
    XDG_CACHE_HOME = "/var/cache/peertube-runner";
    # peertube-runner makes its IPC socket in $XDG_DATA_HOME.
    XDG_DATA_HOME = "/run/peertube-runner";
  };
in
{
  options.services.peertube-runner = {
    enable = lib.mkEnableOption "peertube-runner";
    package = lib.mkPackageOption pkgs [ "peertube" "runner" ] { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "prunner";
      example = "peertube-runner";
      description = "User account under which peertube-runner runs.";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "prunner";
      example = "peertube-runner";
      description = "Group under which peertube-runner runs.";
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          jobs.concurrency = 4;
          ffmpeg = {
            threads = 0; # Let ffmpeg automatically choose.
            nice = 5;
          };
          transcription.model = "large-v3";
        }
      '';
      description = ''
        Configuration for peertube-runner.

        See available configuration options at <https://docs.joinpeertube.org/maintain/tools#configuration>.
      '';
    };
    instancesToRegister = lib.mkOption {
      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            url = lib.mkOption {
              type = lib.types.str;
              example = "https://mypeertubeinstance.com";
              description = "URL of the PeerTube instance.";
            };
            registrationTokenFile = lib.mkOption {
              type = lib.types.path;
              example = "/run/secrets/my-peertube-instance-registration-token";
              description = ''
                Path to a file containing a registration token for the PeerTube instance.

                See how to generate registration tokens at <https://docs.joinpeertube.org/admin/remote-runners#manage-remote-runners>.
              '';
            };
            runnerName = lib.mkOption {
              type = lib.types.str;
              example = "Transcription";
              description = "Runner name declared to the PeerTube instance.";
            };
            runnerDescription = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              example = "Runner for video transcription";
              description = "Runner description declared to the PeerTube instance.";
            };
          };
        });
      default = { };
      example = {
        personal = {
          url = "https://mypeertubeinstance.com";
          registrationTokenFile = "/run/secrets/my-peertube-instance-registration-token";
          runnerName = "Transcription";
          runnerDescription = "Runner for video transcription";
        };
      };
      description = "PeerTube instances to register this runner with.";
    };

    enabledJobTypes = lib.mkOption {
      type = with lib.types; nonEmptyListOf str;
      default = [
        "vod-web-video-transcoding"
        "vod-hls-transcoding"
        "vod-audio-merge-transcoding"
        "live-rtmp-hls-transcoding"
        "video-studio-transcoding"
        "video-transcription"
      ];
      example = [ "video-transcription" ];
      description = "Job types that this runner will execute.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? registeredInstances);
        message = ''
          `services.peertube-runner.settings.registeredInstances` cannot be used.
          Instead, registered instances can be configured with `services.peertube-runner.instancesToRegister`.
        '';
      }
    ];
    warnings = lib.optional (cfg.instancesToRegister == { }) ''
      `services.peertube-runner.instancesToRegister` is empty.
      Instances cannot be manually registered using the command line.
    '';

    services.peertube-runner.settings = {
      transcription = lib.mkIf (lib.elem "video-transcription" cfg.enabledJobTypes) {
        engine = lib.mkDefault "whisper-ctranslate2";
        enginePath = lib.mkDefault (lib.getExe pkgs.whisper-ctranslate2);
      };
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "peertube-runner" ''
        ${lib.concatMapAttrsStringSep "\n" (name: value: ''export ${name}="${toString value}"'') env}

        if [[ "$USER" == ${cfg.user} ]]; then
          exec ${lib.getExe' cfg.package "peertube-runner"} "$@"
        else
          echo "This has to be run with the \`${cfg.user}\` user. Ex: \`sudo -u ${cfg.user} peertube-runner\`"
        fi
      '')
    ];

    systemd.services.peertube-runner = {
      description = "peertube-runner daemon";
      after = [
        "network.target"
        (lib.mkIf config.services.peertube.enable "peertube.service")
      ];
      wantedBy = [ "multi-user.target" ];

      environment = env;
      path = [ pkgs.ffmpeg-headless ];

      script = ''
        config_dir=$XDG_CONFIG_HOME/peertube-runner-nodejs/default
        mkdir -p $config_dir
        config_file=$config_dir/config.toml
        cp -f --no-preserve=mode,ownership ${configFile} $config_file

        ${lib.optionalString ((lib.length (lib.attrNames cfg.instancesToRegister)) > 0) ''
          # Temp config directory for registration commands
          temp_dir=$(mktemp --directory)
          temp_config_dir=$temp_dir/peertube-runner-nodejs/default
          mkdir -p $temp_config_dir
          temp_config_file=$temp_config_dir/config.toml

          mkdir -p $STATE_DIRECTORY/runner_tokens
          ${lib.concatMapAttrsStringSep "\n" (instanceName: instance: ''
            runner_token_file=$STATE_DIRECTORY/runner_tokens/${instanceName}

            # Register any currenctly unregistered instances.
            if [ ! -f $runner_token_file ] || [[ $(cat $runner_token_file) != ptrt-* ]]; then
              # Server has to be running for registration.
              XDG_CONFIG_HOME=$temp_dir ${lib.getExe' cfg.package "peertube-runner"} server &

              XDG_CONFIG_HOME=$temp_dir ${lib.getExe' cfg.package "peertube-runner"} register \
                --url ${lib.escapeShellArg instance.url} \
                --registration-token "$(cat ${instance.registrationTokenFile})" \
                --runner-name ${lib.escapeShellArg instance.runnerName} \
                ${lib.optionalString (
                  instance.runnerDescription != null
                ) ''--runner-description ${lib.escapeShellArg instance.runnerDescription}''}

              # Kill the server
              kill $!

              ${lib.getExe pkgs.yq-go} -e ".registeredInstances[0].runnerToken" \
                $temp_config_file > $runner_token_file
              rm $temp_config_file
            fi

            echo "

            [[registeredInstances]]
            url = \"${instance.url}\"
            runnerToken = \"$(cat $runner_token_file)\"
            runnerName = \"${instance.runnerName}\"
            ${lib.optionalString (
              instance.runnerDescription != null
            ) ''runnerDescription = \"${instance.runnerDescription}\"''}
            " >> $config_file
          '') cfg.instancesToRegister}
        ''}

        # Don't allow changes that won't persist.
        chmod 440 $config_file

        systemd-notify --ready
        exec ${lib.getExe' cfg.package "peertube-runner"} server ${
          lib.concatMapStringsSep " " (jobType: "--enable-job ${jobType}") cfg.enabledJobTypes
        }
      '';
      serviceConfig = {
        Type = "notify";
        NotifyAccess = "all"; # for systemd-notify
        Restart = "always";
        RestartSec = 5;
        SyslogIdentifier = "prunner";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "peertube-runner";
        StateDirectoryMode = "0700";
        CacheDirectory = "peertube-runner";
        CacheDirectoryMode = "0700";
        RuntimeDirectory = "peertube-runner";
        RuntimeDirectoryMode = "0700";

        ProtectSystem = "full";
        NoNewPrivileges = true;
        ProtectHome = true;
        CapabilityBoundingSet = "~CAP_SYS_ADMIN";
      };
    };

    users.users = lib.mkIf (cfg.user == "prunner") {
      ${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
      };
    };
    users.groups = lib.mkIf (cfg.group == "prunner") {
      ${cfg.group} = { };
    };
  };

  meta.maintainers = lib.teams.ngi.members;
}
