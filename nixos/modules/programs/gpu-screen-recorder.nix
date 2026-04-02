{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.gpu-screen-recorder;
  workspaceCfg = cfg.workspaceRecording;
  package = cfg.package.override {
    inherit (config.security) wrapperDir;
  };
  extraArgs = lib.escapeShellArgs workspaceCfg.extraArgs;
  sleepHookScript = pkgs.writeShellScript "gpu-screen-recorder-workspace-recording-sleep-hook" ''
    set -euo pipefail

    action="$1"
    users="$(${pkgs.systemd}/bin/loginctl list-users --no-legend 2>/dev/null | ${pkgs.gawk}/bin/awk '{print $2}' || true)"

    if [ -z "$users" ]; then
      exit 0
    fi

    for user in $users; do
      uid="$(${pkgs.systemd}/bin/loginctl show-user "$user" -p UID --value 2>/dev/null || true)"
      if [ -z "$uid" ]; then
        continue
      fi

      xdgRuntimeDir="/run/user/$uid"
      if [ ! -S "$xdgRuntimeDir/systemd/private" ]; then
        continue
      fi

      ${pkgs.util-linux}/bin/runuser -u "$user" -- \
        env XDG_RUNTIME_DIR="$xdgRuntimeDir" \
        ${pkgs.systemd}/bin/systemctl --user "$action" gpu-screen-recorder-workspace-recording.service || true
    done
  '';
in
{
  options = {
    programs.gpu-screen-recorder = {
      package = lib.mkPackageOption pkgs "gpu-screen-recorder" { };

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install gpu-screen-recorder and generate setcap
          wrappers for promptless recording.
        '';
      };

      workspaceRecording = {
        enable = lib.mkEnableOption "automatic Wayland workspace recording with gpu-screen-recorder";

        outputDirectory = lib.mkOption {
          type = lib.types.str;
          default = "%h/Videos/gpu-screen-recorder/workspace";
          example = "%h/Videos/recordings/workspace";
          description = ''
            Directory where recordings are written.
            systemd user unit specifiers such as `%h` are supported.
            Each recording is stored as a separate `.mkv` file with a
            timestamp-based filename.
          '';
        };

        waitForSession = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to wait for the Wayland, D-Bus, and PipeWire sockets
            before starting the recording.
            This is useful when the service is started by
            `graphical-session.target` before the user session is fully ready.
          '';
        };

        sessionWaitTimeout = lib.mkOption {
          type = lib.types.ints.positive;
          default = 600;
          example = 60;
          description = ''
            How long to wait for the graphical session to become available,
            in seconds.
            This is only used when
            {option}`programs.gpu-screen-recorder.workspaceRecording.waitForSession`
            is enabled.
          '';
        };

        waylandDisplay = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "wayland-0";
          description = ''
            Wayland display name to use. If unset, the first `wayland-*`
            socket in `XDG_RUNTIME_DIR` is used.
          '';
        };

        codec = lib.mkOption {
          type = lib.types.str;
          default = "av1";
          description = "Codec passed to gpu-screen-recorder with `-k`.";
        };

        fps = lib.mkOption {
          type = lib.types.ints.positive;
          default = 20;
          description = "Frame rate passed to gpu-screen-recorder with `-f`.";
        };

        audioSources = lib.mkOption {
          type = lib.types.str;
          default = "default_output|default_input";
          example = "default_output";
          description = ''
            Audio sources passed to gpu-screen-recorder with `-a`.
            The exact syntax is the one accepted by gpu-screen-recorder itself.
          '';
        };

        writeFirstFrameTimestamps = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to write timestamps for the first captured frame to a
            `.ts` sidecar file.
            This can be useful when correlating recordings with events from
            other logs or capture sources.
          '';
        };

        scale = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "1920x1080";
          description = ''
            Optional output resolution passed to gpu-screen-recorder with `-s`.
          '';
        };

        handleSleep = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to stop recording before suspend and start it again after
            resume.
            This is implemented using system services bound to
            `sleep.target` and `post-resume.target`.
          '';
        };

        chunking = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether to periodically restart the recording service to create
              multiple recording files.
              This avoids unbounded single-file recordings and can make
              later processing or transfer easier.
            '';
          };

          minimumDurationMinutes = lib.mkOption {
            type = lib.types.ints.positive;
            default = 30;
            example = 15;
            description = ''
              Minimum time between chunking restarts, in minutes.
            '';
          };

          maximumDurationMinutes = lib.mkOption {
            type = lib.types.ints.positive;
            default = 120;
            example = 45;
            description = ''
              Maximum time between chunking restarts, in minutes.
              The restart timer uses
              {option}`programs.gpu-screen-recorder.workspaceRecording.chunking.minimumDurationMinutes`
              as the base interval and adds up to the difference between the
              two values as randomized delay.
            '';
          };
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "-q"
            "medium"
          ];
          description = ''
            Extra arguments appended to the gpu-screen-recorder command line.
          '';
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable || workspaceCfg.enable) {
      environment.systemPackages = [ cfg.package ];
    })

    (lib.mkIf cfg.enable {
      security.wrappers."gsr-kms-server" = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = lib.getExe' package "gsr-kms-server";
      };
    })

    (lib.mkIf workspaceCfg.enable {
      assertions = [
        {
          assertion = cfg.enable;
          message = ''
            programs.gpu-screen-recorder.workspaceRecording.enable requires
            programs.gpu-screen-recorder.enable to be true.
          '';
        }
        {
          assertion =
            workspaceCfg.chunking.maximumDurationMinutes >= workspaceCfg.chunking.minimumDurationMinutes;
          message = ''
            programs.gpu-screen-recorder.workspaceRecording.chunking.maximumDurationMinutes
            must be greater than or equal to minimumDurationMinutes.
          '';
        }
      ];

      programs.gpu-screen-recorder.enable = lib.mkDefault true;

      systemd.user.services.gpu-screen-recorder-workspace-recording = {
        enable = true;
        description = "Record the active Wayland workspace with gpu-screen-recorder";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];

        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = 2;
        };

        environment = {
          LANG = "C";
          LC_ALL = "C";
          GSR_OUTPUT_DIR = workspaceCfg.outputDirectory;
        };

        script = ''
          set -euo pipefail

          ${pkgs.coreutils}/bin/mkdir -p "''${GSR_OUTPUT_DIR}"

          uid="$(${pkgs.coreutils}/bin/id -u)"
          export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$uid}"

          if [ -z "''${DBUS_SESSION_BUS_ADDRESS:-}" ] && [ -S "''${XDG_RUNTIME_DIR}/bus" ]; then
            export DBUS_SESSION_BUS_ADDRESS="unix:path=''${XDG_RUNTIME_DIR}/bus"
          fi

          if [ -z "''${WAYLAND_DISPLAY:-}" ]; then
            ${lib.optionalString (
              workspaceCfg.waylandDisplay != null
            ) "export WAYLAND_DISPLAY=${lib.escapeShellArg workspaceCfg.waylandDisplay}"}
            ${lib.optionalString (workspaceCfg.waylandDisplay == null) ''
              for socket in "''${XDG_RUNTIME_DIR}"/wayland-*; do
                if [ -S "$socket" ]; then
                  export WAYLAND_DISPLAY="$(${pkgs.coreutils}/bin/basename "$socket")"
                  break
                fi
              done
            ''}
          fi

          ${lib.optionalString workspaceCfg.waitForSession ''
            deadline="$(${pkgs.coreutils}/bin/date -u +%s)"
            deadline="$((deadline + ${toString workspaceCfg.sessionWaitTimeout}))"

            waitForSocket() {
              label="$1"
              socket="$2"
              while [ ! -S "$socket" ]; do
                now="$(${pkgs.coreutils}/bin/date -u +%s)"
                if [ "$now" -ge "$deadline" ]; then
                  echo "gpu-screen-recorder workspace recording: timed out waiting for $label ($socket)" >&2
                  return 1
                fi
                ${pkgs.coreutils}/bin/sleep 1
              done
            }

            if [ -z "''${WAYLAND_DISPLAY:-}" ]; then
              echo "gpu-screen-recorder workspace recording: no WAYLAND_DISPLAY detected in $XDG_RUNTIME_DIR" >&2
              exit 1
            fi

            waitForSocket "wayland" "''${XDG_RUNTIME_DIR}/''${WAYLAND_DISPLAY}"
            waitForSocket "pipewire" "''${XDG_RUNTIME_DIR}/pipewire-0"
            waitForSocket "dbus" "''${XDG_RUNTIME_DIR}/bus"
          ''}

          timestamp="$(${pkgs.coreutils}/bin/date -u +%Y%m%dT%H%M%S)"
          microseconds="$(${pkgs.coreutils}/bin/date +%s%6N)"
          outputFile="''${GSR_OUTPUT_DIR}/workspace-''${timestamp}-''${microseconds}.mkv"

          args=(
            -w workspace
            -k ${lib.escapeShellArg workspaceCfg.codec}
            -f ${toString workspaceCfg.fps}
            -a ${lib.escapeShellArg workspaceCfg.audioSources}
            -o "$outputFile"
            -write-first-frame-ts ${if workspaceCfg.writeFirstFrameTimestamps then "yes" else "no"}
          )
          ${lib.optionalString (
            workspaceCfg.scale != null
          ) "args+=( -s ${lib.escapeShellArg workspaceCfg.scale} )"}
          ${lib.optionalString (workspaceCfg.extraArgs != [ ]) "args+=( ${extraArgs} )"}

          exec ${lib.getExe package} "''${args[@]}"
        '';
      };

      systemd.user.services.gpu-screen-recorder-workspace-recording-restart =
        lib.mkIf workspaceCfg.chunking.enable
          {
            enable = true;
            description = "Restart gpu-screen-recorder workspace recording";
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.systemd}/bin/systemctl --user try-restart gpu-screen-recorder-workspace-recording.service";
            };
          };

      systemd.user.timers.gpu-screen-recorder-workspace-recording-restart =
        lib.mkIf workspaceCfg.chunking.enable
          {
            enable = true;
            description = "Randomly restart gpu-screen-recorder workspace recording";
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnUnitActiveSec = "${toString workspaceCfg.chunking.minimumDurationMinutes}min";
              RandomizedDelaySec = "${
                toString (
                  workspaceCfg.chunking.maximumDurationMinutes - workspaceCfg.chunking.minimumDurationMinutes
                )
              }min";
              Unit = "gpu-screen-recorder-workspace-recording-restart.service";
              Persistent = false;
            };
          };

      systemd.services = lib.mkIf workspaceCfg.handleSleep {
        gpu-screen-recorder-workspace-recording-pre-sleep = {
          description = "Stop gpu-screen-recorder workspace recording before suspend";
          before = [ "sleep.target" ];
          wantedBy = [ "sleep.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${sleepHookScript} stop";
          };
        };

        gpu-screen-recorder-workspace-recording-post-resume = {
          description = "Start gpu-screen-recorder workspace recording after resume";
          wantedBy = [ "post-resume.target" ];
          after = [ "post-resume.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${sleepHookScript} start";
          };
        };
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [ timschumi ];
}
