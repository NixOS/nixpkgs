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
  # Name of file stored in service state directory
  currentConfigTokenFilename = ".current-token";
in
{
  options.services.github-runner = {
    enable = mkOption {
      default = false;
      example = true;
      description = lib.mdDoc ''
        Whether to enable GitHub Actions runner.

        Note: GitHub recommends using self-hosted runners with private repositories only. Learn more here:
        [About self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners).
      '';
      type = lib.types.bool;
    };

    url = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        Repository to add the runner to.

        Changing this option triggers a new runner registration.

        IMPORTANT: If your token is org-wide (not per repository), you need to
        provide a github org link, not a single repository, so do it like this
        `https://github.com/nixos`, not like this
        `https://github.com/nixos/nixpkgs`.
        Otherwise, you are going to get a `404 NotFound`
        from `POST https://api.github.com/actions/runner-registration`
        in the configure script.
      '';
      example = "https://github.com/nixos/nixpkgs";
    };

    tokenFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        The full path to a file which contains either a runner registration token or a
        personal access token (PAT).
        The file should contain exactly one line with the token without any newline.
        If a registration token is given, it can be used to re-register a runner of the same
        name but is time-limited. If the file contains a PAT, the service creates a new
        registration token on startup as needed. Make sure the PAT has a scope of
        `admin:org` for organization-wide registrations or a scope of
        `repo` for a single repository.

        Changing this option or the file's content triggers a new runner registration.
      '';
      example = "/run/secrets/github-runner/nixos.token";
    };

    name = mkOption {
      # Same pattern as for `networking.hostName`
      type = types.strMatching "^$|^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$";
      description = lib.mdDoc ''
        Name of the runner to configure. Defaults to the hostname.

        Changing this option triggers a new runner registration.
      '';
      example = "nixos";
      default = config.networking.hostName;
      defaultText = literalExpression "config.networking.hostName";
    };

    runnerGroup = mkOption {
      type = types.nullOr types.str;
      description = lib.mdDoc ''
        Name of the runner group to add this runner to (defaults to the default runner group).

        Changing this option triggers a new runner registration.
      '';
      default = null;
    };

    extraLabels = mkOption {
      type = types.listOf types.str;
      description = lib.mdDoc ''
        Extra labels in addition to the default (`["self-hosted", "Linux", "X64"]`).

        Changing this option triggers a new runner registration.
      '';
      example = literalExpression ''[ "nixos" ]'';
      default = [ ];
    };

    replace = mkOption {
      type = types.bool;
      description = lib.mdDoc ''
        Replace any existing runner with the same name.

        Without this flag, registering a new runner with the same name fails.
      '';
      default = false;
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      description = lib.mdDoc ''
        Extra packages to add to `PATH` of the service to make them available to workflows.
      '';
      default = [ ];
    };

    package = mkOption {
      type = types.package;
      description = lib.mdDoc ''
        Which github-runner derivation to use.
      '';
      default = pkgs.github-runner;
      defaultText = literalExpression "pkgs.github-runner";
    };

    ephemeral = mkOption {
      type = types.bool;
      description = lib.mdDoc ''
        If enabled, causes the following behavior:

        - Passes the `--ephemeral` flag to the runner configuration script
        - De-registers and stops the runner with GitHub after it has processed one job
        - On stop, systemd wipes the runtime directory (this always happens, even without using the ephemeral option)
        - Restarts the service after its successful exit
        - On start, wipes the state directory and configures a new runner

        You should only enable this option if `tokenFile` points to a file which contains a
        personal access token (PAT). If you're using the option with a registration token, restarting the
        service will fail as soon as the registration token expired.
      '';
      default = false;
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
        RUNNER_ROOT = stateDir;
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
        ExecStart = "${cfg.package}/bin/Runner.Listener run --startuptype service";

        # Does the following, sequentially:
        # - If the module configuration or the token has changed, purge the state directory,
        #   and create the current and the new token file with the contents of the configured
        #   token. While both files have the same content, only the later is accessible by
        #   the service user.
        # - Configure the runner using the new token file. When finished, delete it.
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
            runnerRegistrationConfig = getAttrs [ "name" "tokenFile" "url" "runnerGroup" "extraLabels" "ephemeral" ] cfg;
            newConfigPath = builtins.toFile "${svcName}-config.json" (builtins.toJSON runnerRegistrationConfig);
            newConfigTokenFilename = ".new-token";
            runnerCredFiles = [
              ".credentials"
              ".credentials_rsaparams"
              ".runner"
            ];
            unconfigureRunner = writeScript "unconfigure" ''
              differs=

              if [[ "$(ls -A "$STATE_DIRECTORY")" ]]; then
                # State directory is not empty
                # Set `differs = 1` if current and new runner config differ or if `currentConfigPath` does not exist
                ${pkgs.diffutils}/bin/diff -q '${newConfigPath}' "${currentConfigPath}" >/dev/null 2>&1 || differs=1
                # Also trigger a registration if the token content changed
                ${pkgs.diffutils}/bin/diff -q \
                  "$STATE_DIRECTORY"/${currentConfigTokenFilename} \
                  ${escapeShellArg cfg.tokenFile} \
                  >/dev/null 2>&1 || differs=1
                # If .credentials does not exist, assume a previous run de-registered the runner on stop (ephemeral mode)
                [[ ! -f "$STATE_DIRECTORY/.credentials" ]] && differs=1
              fi

              if [[ -n "$differs" ]]; then
                echo "Config has changed, removing old runner state."
                # In ephemeral mode, the runner deletes the `.credentials` file after de-registering it with GitHub
                [[ -f "$STATE_DIRECTORY/.credentials" ]] && echo "The old runner will still appear in the GitHub Actions UI." \
                  "You have to remove it manually."
                find "$STATE_DIRECTORY/" -mindepth 1 -delete

                # Copy the configured token file to the state dir and allow the service user to read the file
                install --mode=666 ${escapeShellArg cfg.tokenFile} "$STATE_DIRECTORY/${newConfigTokenFilename}"
                # Also copy current file to allow for a diff on the next start
                install --mode=600 ${escapeShellArg cfg.tokenFile} "$STATE_DIRECTORY/${currentConfigTokenFilename}"
              fi
            '';
            configureRunner = writeScript "configure" ''
              if [[ -e "$STATE_DIRECTORY/${newConfigTokenFilename}" ]]; then
                echo "Configuring GitHub Actions Runner"

                args=(
                  --unattended
                  --disableupdate
                  --work "$RUNTIME_DIRECTORY"
                  --url ${escapeShellArg cfg.url}
                  --labels ${escapeShellArg (concatStringsSep "," cfg.extraLabels)}
                  --name ${escapeShellArg cfg.name}
                  ${optionalString cfg.replace "--replace"}
                  ${optionalString (cfg.runnerGroup != null) "--runnergroup ${escapeShellArg cfg.runnerGroup}"}
                  ${optionalString cfg.ephemeral "--ephemeral"}
                )

                # If the token file contains a PAT (i.e., it starts with "ghp_"), we have to use the --pat option,
                # if it is not a PAT, we assume it contains a registration token and use the --token option
                token=$(<"$STATE_DIRECTORY/${newConfigTokenFilename}")
                if [[ "$token" =~ ^ghp_* ]]; then
                  args+=(--pat "$token")
                else
                  args+=(--token "$token")
                fi

                ${cfg.package}/bin/config.sh "''${args[@]}"

                # Move the automatically created _diag dir to the logs dir
                mkdir -p  "$STATE_DIRECTORY/_diag"
                cp    -r  "$STATE_DIRECTORY/_diag/." "$LOGS_DIRECTORY/"
                rm    -rf "$STATE_DIRECTORY/_diag/"

                # Cleanup token from config
                rm "$STATE_DIRECTORY/${newConfigTokenFilename}"

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
            "+${unconfigureRunner}" # runs as root
            configureRunner
            setupRuntimeDir
          ];

        # If running in ephemeral mode, restart the service on-exit (i.e., successful de-registration of the runner)
        # to trigger a fresh registration.
        Restart = if cfg.ephemeral then "on-success" else "no";

        # Contains _diag
        LogsDirectory = [ systemdDir ];
        # Default RUNNER_ROOT which contains ephemeral Runner data
        RuntimeDirectory = [ systemdDir ];
        # Home of persistent runner data, e.g., credentials
        StateDirectory = [ systemdDir ];
        StateDirectoryMode = "0700";
        WorkingDirectory = runtimeDir;

        InaccessiblePaths = [
          # Token file path given in the configuration
          cfg.tokenFile
          # Token file in the state directory
          "${stateDir}/${currentConfigTokenFilename}"
        ];

        # By default, use a dynamically allocated user
        DynamicUser = true;

        KillSignal = "SIGINT";

        # Hardening (may overlap with DynamicUser=)
        # The following options are only for optimizing:
        # systemd-analyze security github-runner
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
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
        ProtectProc = "invisible";
        SystemCallFilter = [
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK" ];

        # Needs network access
        PrivateNetwork = false;
        # Cannot be true due to Node
        MemoryDenyWriteExecute = false;

        # The more restrictive "pid" option makes `nix` commands in CI emit
        # "GC Warning: Couldn't read /proc/stat"
        # You may want to set this to "pid" if not using `nix` commands
        ProcSubset = "all";
        # Coverage programs for compiled code such as `cargo-tarpaulin` disable
        # ASLR (address space layout randomization) which requires the
        # `personality` syscall
        # You may want to set this to `true` if not using coverage tooling on
        # compiled code
        LockPersonality = false;
      };
    };
  };
}
