{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.github-runner;
  svcName = "github-runner";
  systemdDir = "${svcName}/${cfg.name}";
  # %t: Runtime directory root (usually /run); see systemd.unit(5)
  runtimeDir = "%t/${systemdDir}";
  # %S: State directory root (usually /var/lib); see systemd.unit(5)
  stateDir = "%S/${systemdDir}";
  # %L: Log directory root (usually /var/log); see systemd.unit(5)
  logsDir = "%L/${systemdDir}";
in
{
  options.services.github-runner = {
    enable = mkOption {
      default = false;
      example = true;
      description = ''
        Whether to enable GitHub Actions runner.

        Note: GitHub recommends using self-hosted runners with private repositories only. Learn more here:
        <link xlink:href="https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners"
        >About self-hosted runners</link>.
      '';
      type = lib.types.bool;
    };

    url = mkOption {
      type = types.str;
      description = ''
        Repository to add the runner to.

        Changing this option triggers a new runner registration.
      '';
      example = "https://github.com/nixos/nixpkgs";
    };

    tokenFile = mkOption {
      type = types.path;
      description = ''
        The full path to a file which contains the runner registration token.
        The file should contain exactly one line with the token without any newline.
        The token can be used to re-register a runner of the same name but is time-limited.

        Changing this option or the file's content triggers a new runner registration.
      '';
      example = "/run/secrets/github-runner/nixos.token";
    };

    name = mkOption {
      # Same pattern as for `networking.hostName`
      type = types.strMatching "^$|^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$";
      description = ''
        Name of the runner to configure. Defaults to the hostname.

        Changing this option triggers a new runner registration.
      '';
      example = "nixos";
      default = config.networking.hostName;
    };

    runnerGroup = mkOption {
      type = types.nullOr types.str;
      description = ''
        Name of the runner group to add this runner to (defaults to the default runner group).

        Changing this option triggers a new runner registration.
      '';
      default = null;
    };

    extraLabels = mkOption {
      type = types.listOf types.str;
      description = ''
        Extra labels in addition to the default (<literal>["self-hosted", "Linux", "X64"]</literal>).

        Changing this option triggers a new runner registration.
      '';
      example = literalExample ''[ "nixos" ]'';
      default = [ ];
    };

    replace = mkOption {
      type = types.bool;
      description = ''
        Replace any existing runner with the same name.

        Without this flag, registering a new runner with the same name fails.
      '';
      default = false;
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      description = ''
        Extra packages to add to <literal>PATH</literal> of the service to make them available to workflows.
      '';
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    warnings = optionals (isStorePath cfg.tokenFile) [
      ''
        `services.github-runner.tokenFile` points to the Nix store and, therefore, is world-readable.
        Consider using a path outside of the Nix store to keep the token private.
      ''
    ];

    systemd.services.${svcName} = {
      description = "GitHub Actions runner";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network.target" "network-online.target" ];

      environment = {
        HOME = runtimeDir;
        RUNNER_ROOT = runtimeDir;
      };

      path = (with pkgs; [
        bash
        coreutils
        git
        gnutar
        gzip
      ]) ++ [
        config.nix.package
      ] ++ cfg.extraPackages;

      serviceConfig = rec {
        ExecStart = "${pkgs.github-runner}/bin/runsvc.sh";

        # Does the following, sequentially:
        # - Copy the current and the previous `tokenFile` to the $RUNTIME_DIRECTORY
        #   and make it accessible to the service user to allow for a content
        #   comparison.
        # - If the module configuration or the token has changed, clear the state directory.
        # - Configure the runner.
        # - Copy the configured `tokenFile` to the $STATE_DIRECTORY and make it
        #   inaccessible to the service user.
        # - Set up the directory structure by creating the necessary symlinks.
        ExecStartPre =
          let
            # Wrapper script which expects the full path of the state, runtime and logs
            # directory as arguments. Overrides the respective systemd variables to provide
            # unambiguous directory names. This becomes relevant, for example, if the
            # caller overrides any of the StateDirectory=, RuntimeDirectory= or LogDirectory=
            # to contain more than one directory. This causes systemd to set the respective
            # environment variables with the path of all of the given directories, separated
            # by a colon.
            writeScript = name: lines: pkgs.writeShellScript "${svcName}-${name}.sh" ''
              set -euo pipefail

              STATE_DIRECTORY="$1"
              RUNTIME_DIRECTORY="$2"
              LOGS_DIRECTORY="$3"

              ${lines}
            '';
            currentConfigPath = "$STATE_DIRECTORY/.nixos-current-config.json";
            runnerRegistrationConfig = getAttrs [ "name" "tokenFile" "url" "runnerGroup" "extraLabels" ] cfg;
            newConfigPath = builtins.toFile "${svcName}-config.json" (builtins.toJSON runnerRegistrationConfig);
            currentConfigTokenFilename = ".current-token";
            newConfigTokenFilename = ".new-token";
            runnerCredFiles = [
              ".credentials"
              ".credentials_rsaparams"
              ".runner"
            ];
            ownConfigTokens = writeScript "own-config-tokens" ''
              # Copy current and new token file to runtime dir and make it accessible to the service user
              cp ${escapeShellArg cfg.tokenFile} "$RUNTIME_DIRECTORY/${newConfigTokenFilename}"
              chmod 600 "$RUNTIME_DIRECTORY/${newConfigTokenFilename}"
              chown "$USER" "$RUNTIME_DIRECTORY/${newConfigTokenFilename}"

              if [[ -e "$STATE_DIRECTORY/${currentConfigTokenFilename}" ]]; then
                cp "$STATE_DIRECTORY/${currentConfigTokenFilename}" "$RUNTIME_DIRECTORY/${currentConfigTokenFilename}"
                chmod 600 "$RUNTIME_DIRECTORY/${currentConfigTokenFilename}"
                chown "$USER" "$RUNTIME_DIRECTORY/${currentConfigTokenFilename}"
              fi
            '';
            disownConfigTokens = writeScript "disown-config-tokens" ''
              # Make the token inaccessible to the runner service user
              chmod 600 "$STATE_DIRECTORY/${currentConfigTokenFilename}"
              chown root:root "$STATE_DIRECTORY/${currentConfigTokenFilename}"
            '';
            unconfigureRunner = writeScript "unconfigure" ''
              differs=
              # Set `differs = 1` if current and new runner config differ or if `currentConfigPath` does not exist
              ${pkgs.diffutils}/bin/diff -q '${newConfigPath}' "${currentConfigPath}" >/dev/null 2>&1 || differs=1
              # Also trigger a registration if the token content changed
              ${pkgs.diffutils}/bin/diff -q \
                "$RUNTIME_DIRECTORY"/{${currentConfigTokenFilename},${newConfigTokenFilename}} \
                >/dev/null 2>&1 || differs=1

              if [[ -n "$differs" ]]; then
                echo "Config has changed, removing old runner state."
                echo "The old runner will still appear in the GitHub Actions UI." \
                  "You have to remove it manually."
                find "$STATE_DIRECTORY/" -mindepth 1 -delete
              fi
            '';
            configureRunner = writeScript "configure" ''
              empty=$(ls -A "$STATE_DIRECTORY")
              if [[ -z "$empty" ]]; then
                echo "Configuring GitHub Actions Runner"
                token=$(< "$RUNTIME_DIRECTORY"/${newConfigTokenFilename})
                RUNNER_ROOT="$STATE_DIRECTORY" ${pkgs.github-runner}/bin/config.sh \
                  --unattended \
                  --work "$RUNTIME_DIRECTORY" \
                  --url ${escapeShellArg cfg.url} \
                  --token "$token" \
                  --labels ${escapeShellArg (concatStringsSep "," cfg.extraLabels)} \
                  --name ${escapeShellArg cfg.name} \
                  ${optionalString cfg.replace "--replace"} \
                  ${optionalString (cfg.runnerGroup != null) "--runnergroup ${escapeShellArg cfg.runnerGroup}"}

                # Move the automatically created _diag dir to the logs dir
                mkdir -p  "$STATE_DIRECTORY/_diag"
                cp    -r  "$STATE_DIRECTORY/_diag/." "$LOGS_DIRECTORY/"
                rm    -rf "$STATE_DIRECTORY/_diag/"

                # Cleanup token from config
                rm -f "$RUNTIME_DIRECTORY"/${currentConfigTokenFilename}
                mv    "$RUNTIME_DIRECTORY"/${newConfigTokenFilename} "$STATE_DIRECTORY/${currentConfigTokenFilename}"

                # Symlink to new config
                ln -s '${newConfigPath}' "${currentConfigPath}"
              fi
            '';
            setupRuntimeDir = writeScript "setup-runtime-dirs" ''
              # Link _diag dir
              ln -s "$LOGS_DIRECTORY" "$RUNTIME_DIRECTORY/_diag"

              # Link the runner credentials to the runtime dir
              ln -s "$STATE_DIRECTORY"/{${lib.concatStringsSep "," runnerCredFiles}} "$RUNTIME_DIRECTORY/"
            '';
          in
          map (x: "${x} ${escapeShellArgs [ stateDir runtimeDir logsDir ]}") [
            "+${ownConfigTokens}" # runs as root
            unconfigureRunner
            configureRunner
            "+${disownConfigTokens}" # runs as root
            setupRuntimeDir
          ];

        # Contains _diag
        LogsDirectory = [ systemdDir ];
        # Default RUNNER_ROOT which contains ephemeral Runner data
        RuntimeDirectory = [ systemdDir ];
        # Home of persistent runner data, e.g., credentials
        StateDirectory = [ systemdDir ];
        StateDirectoryMode = "0700";
        WorkingDirectory = runtimeDir;

        # By default, use a dynamically allocated user
        DynamicUser = true;

        KillMode = "process";
        KillSignal = "SIGTERM";

        # Hardening (may overlap with DynamicUser=)
        # The following options are only for optimizing:
        # systemd-analyze security github-runner
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        UMask = "0066";

        # Needs network access
        PrivateNetwork = false;
        # Cannot be true due to Node
        MemoryDenyWriteExecute = false;
      };
    };
  };
}
