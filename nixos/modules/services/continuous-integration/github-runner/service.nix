{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  config.assertions = flatten (
    flip mapAttrsToList config.services.github-runners (
      name: cfg:
      map (mkIf cfg.enable) [
        {
          assertion = !cfg.noDefaultLabels || (cfg.extraLabels != [ ]);
          message = "`services.github-runners.${name}`: The `extraLabels` option is mandatory if `noDefaultLabels` is set";
        }
        {
          assertion = cfg.group == null || cfg.user != null;
          message = ''`services.github-runners.${name}`: Setting `group` while leaving `user` unset runs the service as `root`. If this is really what you want, set `user = "root"` explicitly'';
        }
      ]
    )
  );

  config.systemd.services =
    let
      enabledRunners = filterAttrs (_: cfg: cfg.enable) config.services.github-runners;
    in
    (flip mapAttrs' enabledRunners (
      name: cfg:
      let
        svcName = "github-runner-${name}";
        systemdDir = "github-runner/${name}";

        # %t: Runtime directory root (usually /run); see systemd.unit(5)
        runtimeDir = "%t/${systemdDir}";
        # %S: State directory root (usually /var/lib); see systemd.unit(5)
        stateDir = "%S/${systemdDir}";
        # %L: Log directory root (usually /var/log); see systemd.unit(5)
        logsDir = "%L/${systemdDir}";
        # Name of file stored in service state directory
        currentConfigTokenFilename = ".current-token";

        workDir = if cfg.workDir == null then runtimeDir else cfg.workDir;
        # Support old github-runner versions which don't have the `nodeRuntimes` arg yet.
        package = cfg.package.override (
          old: optionalAttrs (hasAttr "nodeRuntimes" old) { inherit (cfg) nodeRuntimes; }
        );
      in
      nameValuePair svcName {
        description = "GitHub Actions runner";

        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [
          "network.target"
          "network-online.target"
        ];

        environment = {
          HOME = workDir;
          RUNNER_ROOT = stateDir;
        } // cfg.extraEnvironment;

        path =
          (with pkgs; [
            bashInteractive
            coreutils
            git
            gnutar
            gzip
          ])
          ++ [
            config.nix.package
          ]
          ++ cfg.extraPackages;

        serviceConfig = mkMerge [
          {
            ExecStart = "${package}/bin/Runner.Listener run --startuptype service";

            # Does the following, sequentially:
            # - If the module configuration or the token has changed, purge the state directory,
            #   and create the current and the new token file with the contents of the configured
            #   token. While both files have the same content, only the later is accessible by
            #   the service user.
            # - Configure the runner using the new token file. When finished, delete it.
            # - Set up the directory structure by creating the necessary symlinks.
            ExecStartPre =
              let
                # Wrapper script which expects the full path of the state, working and logs
                # directory as arguments. Overrides the respective systemd variables to provide
                # unambiguous directory names. This becomes relevant, for example, if the
                # caller overrides any of the StateDirectory=, RuntimeDirectory= or LogDirectory=
                # to contain more than one directory. This causes systemd to set the respective
                # environment variables with the path of all of the given directories, separated
                # by a colon.
                writeScript =
                  name: lines:
                  pkgs.writeShellScript "${svcName}-${name}.sh" ''
                    set -euo pipefail

                    STATE_DIRECTORY="$1"
                    WORK_DIRECTORY="$2"
                    LOGS_DIRECTORY="$3"

                    ${lines}
                  '';
                runnerRegistrationConfig = getAttrs [
                  "ephemeral"
                  "extraLabels"
                  "name"
                  "noDefaultLabels"
                  "runnerGroup"
                  "tokenFile"
                  "url"
                  "workDir"
                ] cfg;
                newConfigPath = builtins.toFile "${svcName}-config.json" (builtins.toJSON runnerRegistrationConfig);
                currentConfigPath = "$STATE_DIRECTORY/.nixos-current-config.json";
                newConfigTokenPath = "$STATE_DIRECTORY/.new-token";
                currentConfigTokenPath = "$STATE_DIRECTORY/${currentConfigTokenFilename}";

                runnerCredFiles = [
                  ".credentials"
                  ".credentials_rsaparams"
                  ".runner"
                ];
                unconfigureRunner = writeScript "unconfigure" ''
                  copy_tokens() {
                    # Copy the configured token file to the state dir and allow the service user to read the file
                    install --mode=666 ${escapeShellArg cfg.tokenFile} "${newConfigTokenPath}"
                    # Also copy current file to allow for a diff on the next start
                    install --mode=600 ${escapeShellArg cfg.tokenFile} "${currentConfigTokenPath}"
                  }
                  clean_state() {
                    find "$STATE_DIRECTORY/" -mindepth 1 -delete
                    copy_tokens
                  }
                  diff_config() {
                    changed=0
                    # Check for module config changes
                    [[ -f "${currentConfigPath}" ]] \
                      && ${pkgs.diffutils}/bin/diff -q '${newConfigPath}' "${currentConfigPath}" >/dev/null 2>&1 \
                      || changed=1
                    # Also check the content of the token file
                    [[ -f "${currentConfigTokenPath}" ]] \
                      && ${pkgs.diffutils}/bin/diff -q "${currentConfigTokenPath}" ${escapeShellArg cfg.tokenFile} >/dev/null 2>&1 \
                      || changed=1
                    # If the config has changed, remove old state and copy tokens
                    if [[ "$changed" -eq 1 ]]; then
                      echo "Config has changed, removing old runner state."
                      echo "The old runner will still appear in the GitHub Actions UI." \
                           "You have to remove it manually."
                      clean_state
                    fi
                  }
                  if [[ "${optionalString cfg.ephemeral "1"}" ]]; then
                    # In ephemeral mode, we always want to start with a clean state
                    clean_state
                  elif [[ "$(ls -A "$STATE_DIRECTORY")" ]]; then
                    # There are state files from a previous run; diff them to decide if we need a new registration
                    diff_config
                  else
                    # The state directory is entirely empty which indicates a first start
                    copy_tokens
                  fi
                  # Always clean workDir
                  find -H "$WORK_DIRECTORY" -mindepth 1 -delete
                '';
                configureRunner =
                  writeScript "configure" # bash
                    ''
                      if [[ -e "${newConfigTokenPath}" ]]; then
                        echo "Configuring GitHub Actions Runner"
                        # shellcheck disable=SC2054  # don't complain about commas in --labels
                        args=(
                          --unattended
                          --disableupdate
                          --work "$WORK_DIRECTORY"
                          --url ${escapeShellArg cfg.url}
                          --labels ${escapeShellArg (concatStringsSep "," cfg.extraLabels)}
                          ${optionalString (cfg.name != null) "--name ${escapeShellArg cfg.name}"}
                          ${optionalString cfg.replace "--replace"}
                          ${optionalString (cfg.runnerGroup != null) "--runnergroup ${escapeShellArg cfg.runnerGroup}"}
                          ${optionalString cfg.ephemeral "--ephemeral"}
                          ${optionalString cfg.noDefaultLabels "--no-default-labels"}
                        )
                        # If the token file contains a PAT (i.e., it starts with "ghp_" or "github_pat_"), we have to use the --pat option,
                        # if it is not a PAT, we assume it contains a registration token and use the --token option
                        token=$(<"${newConfigTokenPath}")
                        if [[ "$token" =~ ^ghp_* ]] || [[ "$token" =~ ^github_pat_* ]]; then
                          args+=(--pat "$token")
                        else
                          args+=(--token "$token")
                        fi
                        ${package}/bin/Runner.Listener configure "''${args[@]}"
                        # Move the automatically created _diag dir to the logs dir
                        mkdir -p  "$STATE_DIRECTORY/_diag"
                        cp    -r  "$STATE_DIRECTORY/_diag/." "$LOGS_DIRECTORY/"
                        rm    -rf "$STATE_DIRECTORY/_diag/"
                        # Cleanup token from config
                        rm "${newConfigTokenPath}"
                        # Symlink to new config
                        ln -s '${newConfigPath}' "${currentConfigPath}"
                      fi
                    '';
                setupWorkDir = writeScript "setup-work-dirs" ''
                  # Link _diag dir
                  ln -s "$LOGS_DIRECTORY" "$WORK_DIRECTORY/_diag"

                  # Link the runner credentials to the work dir
                  ln -s "$STATE_DIRECTORY"/{${lib.concatStringsSep "," runnerCredFiles}} "$WORK_DIRECTORY/"
                '';
              in
              map
                (
                  x:
                  "${x} ${
                    escapeShellArgs [
                      stateDir
                      workDir
                      logsDir
                    ]
                  }"
                )
                [
                  "+${unconfigureRunner}" # runs as root
                  configureRunner
                  setupWorkDir
                ];

            # If running in ephemeral mode, restart the service on-exit (i.e., successful de-registration of the runner)
            # to trigger a fresh registration.
            Restart = if cfg.ephemeral then "on-success" else "no";
            # If the runner exits with `ReturnCode.RetryableError = 2`, always restart the service:
            # https://github.com/actions/runner/blob/40ed7f8/src/Runner.Common/Constants.cs#L146
            RestartForceExitStatus = [ 2 ];

            # Contains _diag
            LogsDirectory = [ systemdDir ];
            # Default RUNNER_ROOT which contains ephemeral Runner data
            RuntimeDirectory = [ systemdDir ];
            # Home of persistent runner data, e.g., credentials
            StateDirectory = [ systemdDir ];
            StateDirectoryMode = "0700";
            WorkingDirectory = workDir;

            InaccessiblePaths = [
              # Token file path given in the configuration, if visible to the service
              "-${cfg.tokenFile}"
              # Token file in the state directory
              "${stateDir}/${currentConfigTokenFilename}"
            ];

            KillSignal = "SIGINT";

            # Hardening (may overlap with DynamicUser=)
            # The following options are only for optimizing:
            # systemd-analyze security github-runner
            AmbientCapabilities = mkBefore [ "" ];
            CapabilityBoundingSet = mkBefore [ "" ];
            # ProtectClock= adds DeviceAllow=char-rtc r
            DeviceAllow = mkBefore [ "" ];
            NoNewPrivileges = mkDefault true;
            PrivateDevices = mkDefault true;
            PrivateMounts = mkDefault true;
            PrivateTmp = mkDefault true;
            PrivateUsers = mkDefault true;
            ProtectClock = mkDefault true;
            ProtectControlGroups = mkDefault true;
            ProtectHome = mkDefault true;
            ProtectHostname = mkDefault true;
            ProtectKernelLogs = mkDefault true;
            ProtectKernelModules = mkDefault true;
            ProtectKernelTunables = mkDefault true;
            ProtectSystem = mkDefault "strict";
            RemoveIPC = mkDefault true;
            RestrictNamespaces = mkDefault true;
            RestrictRealtime = mkDefault true;
            RestrictSUIDSGID = mkDefault true;
            UMask = mkDefault "0066";
            ProtectProc = mkDefault "invisible";
            SystemCallFilter = mkBefore [
              "~@clock"
              "~@cpu-emulation"
              "~@module"
              "~@mount"
              "~@obsolete"
              "~@raw-io"
              "~@reboot"
              "~capset"
              "~setdomainname"
              "~sethostname"
            ];
            RestrictAddressFamilies = mkBefore [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
              "AF_NETLINK"
            ];

            BindPaths = lib.optionals (cfg.workDir != null) [ cfg.workDir ];

            # Needs network access
            PrivateNetwork = mkDefault false;
            # Cannot be true due to Node
            MemoryDenyWriteExecute = mkDefault false;

            # The more restrictive "pid" option makes `nix` commands in CI emit
            # "GC Warning: Couldn't read /proc/stat"
            # You may want to set this to "pid" if not using `nix` commands
            ProcSubset = mkDefault "all";
            # Coverage programs for compiled code such as `cargo-tarpaulin` disable
            # ASLR (address space layout randomization) which requires the
            # `personality` syscall
            # You may want to set this to `true` if not using coverage tooling on
            # compiled code
            LockPersonality = mkDefault false;

            DynamicUser = mkDefault true;
          }
          (mkIf (cfg.user != null) {
            DynamicUser = false;
            User = cfg.user;
          })
          (mkIf (cfg.group != null) {
            DynamicUser = false;
            Group = cfg.group;
          })
          cfg.serviceOverrides
        ];
      }
    ));
}
