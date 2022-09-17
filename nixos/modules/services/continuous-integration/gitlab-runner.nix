{ config, lib, pkgs, ... }:
with builtins;
with lib;
let
  cfg = config.services.gitlab-runner;
  hasDocker = config.virtualisation.docker.enable;
  hashedServices = mapAttrs'
    (name: service: nameValuePair
      "${name}_${config.networking.hostName}_${
        substring 0 12
        (hashString "md5" (unsafeDiscardStringContext (toJSON service)))}"
      service)
    cfg.services;
  configPath = "$HOME/.gitlab-runner/config.toml";
  configureScript = pkgs.writeShellScriptBin "gitlab-runner-configure" (
    if (cfg.configFile != null) then ''
      mkdir -p $(dirname ${configPath})
      cp ${cfg.configFile} ${configPath}
      # make config file readable by service
      chown -R --reference=$HOME $(dirname ${configPath})
    '' else ''
      export CONFIG_FILE=${configPath}

      mkdir -p $(dirname ${configPath})
      touch ${configPath}

      # update global options
      remarshal --if toml --of json ${configPath} \
        | jq -cM 'with_entries(select([.key] | inside(["runners"])))' \
        | jq -scM '.[0] + .[1]' - <(echo ${escapeShellArg (toJSON cfg.settings)}) \
        | remarshal --if json --of toml \
        | sponge ${configPath}

      # remove no longer existing services
      gitlab-runner verify --delete

      # current and desired state
      NEEDED_SERVICES=$(echo ${concatStringsSep " " (attrNames hashedServices)} | tr " " "\n")
      REGISTERED_SERVICES=$(gitlab-runner list 2>&1 | grep 'Executor' | awk '{ print $1 }')

      # difference between current and desired state
      NEW_SERVICES=$(grep -vxF -f <(echo "$REGISTERED_SERVICES") <(echo "$NEEDED_SERVICES") || true)
      OLD_SERVICES=$(grep -vxF -f <(echo "$NEEDED_SERVICES") <(echo "$REGISTERED_SERVICES") || true)

      # register new services
      ${concatStringsSep "\n" (mapAttrsToList (name: service: ''
        if echo "$NEW_SERVICES" | grep -xq "${name}"; then
          bash -c ${escapeShellArg (concatStringsSep " \\\n " ([
            "set -a && source ${service.registrationConfigFile} &&"
            "gitlab-runner register"
            "--non-interactive"
            (if service.description != null then "--description \"${service.description}\"" else "--name '${name}'")
            "--executor ${service.executor}"
            "--limit ${toString service.limit}"
            "--request-concurrency ${toString service.requestConcurrency}"
            "--maximum-timeout ${toString service.maximumTimeout}"
          ] ++ service.registrationFlags
            ++ optional (service.buildsDir != null)
            "--builds-dir ${service.buildsDir}"
            ++ optional (service.cloneUrl != null)
            "--clone-url ${service.cloneUrl}"
            ++ optional (service.preCloneScript != null)
            "--pre-clone-script ${service.preCloneScript}"
            ++ optional (service.preBuildScript != null)
            "--pre-build-script ${service.preBuildScript}"
            ++ optional (service.postBuildScript != null)
            "--post-build-script ${service.postBuildScript}"
            ++ optional (service.tagList != [ ])
            "--tag-list ${concatStringsSep "," service.tagList}"
            ++ optional service.runUntagged
            "--run-untagged"
            ++ optional service.protected
            "--access-level ref_protected"
            ++ optional service.debugTraceDisabled
            "--debug-trace-disabled"
            ++ map (e: "--env ${escapeShellArg e}") (mapAttrsToList (name: value: "${name}=${value}") service.environmentVariables)
            ++ optionals (hasPrefix "docker" service.executor) (
              assert (
                assertMsg (service.dockerImage != null)
                  "dockerImage option is required for ${service.executor} executor (${name})");
              [ "--docker-image ${service.dockerImage}" ]
              ++ optional service.dockerDisableCache
              "--docker-disable-cache"
              ++ optional service.dockerPrivileged
              "--docker-privileged"
              ++ map (v: "--docker-volumes ${escapeShellArg v}") service.dockerVolumes
              ++ map (v: "--docker-extra-hosts ${escapeShellArg v}") service.dockerExtraHosts
              ++ map (v: "--docker-allowed-images ${escapeShellArg v}") service.dockerAllowedImages
              ++ map (v: "--docker-allowed-services ${escapeShellArg v}") service.dockerAllowedServices
            )
          ))} && sleep 1 || exit 1
        fi
      '') hashedServices)}

      # unregister old services
      for NAME in $(echo "$OLD_SERVICES")
      do
        [ ! -z "$NAME" ] && gitlab-runner unregister \
          --name "$NAME" && sleep 1
      done

      # make config file readable by service
      chown -R --reference=$HOME $(dirname ${configPath})
    '');
  startScript = pkgs.writeShellScriptBin "gitlab-runner-start" ''
    export CONFIG_FILE=${configPath}
    exec gitlab-runner run --working-directory $HOME
  '';
in
{
  options.services.gitlab-runner = {
    enable = mkEnableOption (lib.mdDoc "Gitlab Runner");
    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Configuration file for gitlab-runner.

        {option}`configFile` takes precedence over {option}`services`.
        {option}`checkInterval` and {option}`concurrent` will be ignored too.

        This option is deprecated, please use {option}`services` instead.
        You can use {option}`registrationConfigFile` and
        {option}`registrationFlags`
        for settings not covered by this module.
      '';
    };
    settings = mkOption {
      type = types.submodule {
        freeformType = (pkgs.formats.json { }).type;
      };
      default = { };
      description = lib.mdDoc ''
        Global gitlab-runner configuration. See
        <https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-global-section>
        for supported values.
      '';
    };
    gracefulTermination = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Finish all remaining jobs before stopping.
        If not set gitlab-runner will stop immediatly without waiting
        for jobs to finish, which will lead to failed builds.
      '';
    };
    gracefulTimeout = mkOption {
      type = types.str;
      default = "infinity";
      example = "5min 20s";
      description = lib.mdDoc ''
        Time to wait until a graceful shutdown is turned into a forceful one.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.gitlab-runner;
      defaultText = literalExpression "pkgs.gitlab-runner";
      example = literalExpression "pkgs.gitlab-runner_1_11";
      description = lib.mdDoc "Gitlab Runner package to use.";
    };
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = lib.mdDoc ''
        Extra packages to add to PATH for the gitlab-runner process.
      '';
    };
    services = mkOption {
      description = lib.mdDoc "GitLab Runner services.";
      default = { };
      example = literalExpression ''
        {
          # runner for building in docker via host's nix-daemon
          # nix store will be readable in runner, might be insecure
          nix = {
            # File should contain at least these two variables:
            # `CI_SERVER_URL`
            # `REGISTRATION_TOKEN`
            registrationConfigFile = "/run/secrets/gitlab-runner-registration";
            dockerImage = "alpine";
            dockerVolumes = [
              "/nix/store:/nix/store:ro"
              "/nix/var/nix/db:/nix/var/nix/db:ro"
              "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
            ];
            dockerDisableCache = true;
            preBuildScript = pkgs.writeScript "setup-container" '''
              mkdir -p -m 0755 /nix/var/log/nix/drvs
              mkdir -p -m 0755 /nix/var/nix/gcroots
              mkdir -p -m 0755 /nix/var/nix/profiles
              mkdir -p -m 0755 /nix/var/nix/temproots
              mkdir -p -m 0755 /nix/var/nix/userpool
              mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
              mkdir -p -m 1777 /nix/var/nix/profiles/per-user
              mkdir -p -m 0755 /nix/var/nix/profiles/per-user/root
              mkdir -p -m 0700 "$HOME/.nix-defexpr"

              . ''${pkgs.nix}/etc/profile.d/nix.sh

              ''${pkgs.nix}/bin/nix-env -i ''${concatStringsSep " " (with pkgs; [ nix cacert git openssh ])}

              ''${pkgs.nix}/bin/nix-channel --add https://nixos.org/channels/nixpkgs-unstable
              ''${pkgs.nix}/bin/nix-channel --update nixpkgs
            ''';
            environmentVariables = {
              ENV = "/etc/profile";
              USER = "root";
              NIX_REMOTE = "daemon";
              PATH = "/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin";
              NIX_SSL_CERT_FILE = "/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt";
            };
            tagList = [ "nix" ];
          };
          # runner for building docker images
          docker-images = {
            # File should contain at least these two variables:
            # `CI_SERVER_URL`
            # `REGISTRATION_TOKEN`
            registrationConfigFile = "/run/secrets/gitlab-runner-registration";
            dockerImage = "docker:stable";
            dockerVolumes = [
              "/var/run/docker.sock:/var/run/docker.sock"
            ];
            tagList = [ "docker-images" ];
          };
          # runner for executing stuff on host system (very insecure!)
          # make sure to add required packages (including git!)
          # to `environment.systemPackages`
          shell = {
            # File should contain at least these two variables:
            # `CI_SERVER_URL`
            # `REGISTRATION_TOKEN`
            registrationConfigFile = "/run/secrets/gitlab-runner-registration";
            executor = "shell";
            tagList = [ "shell" ];
          };
          # runner for everything else
          default = {
            # File should contain at least these two variables:
            # `CI_SERVER_URL`
            # `REGISTRATION_TOKEN`
            registrationConfigFile = "/run/secrets/gitlab-runner-registration";
            dockerImage = "debian:stable";
          };
        }
      '';
      type = types.attrsOf (types.submodule {
        options = {
          registrationConfigFile = mkOption {
            type = types.path;
            description = lib.mdDoc ''
              Absolute path to a file with environment variables
              used for gitlab-runner registration.
              A list of all supported environment variables can be found in
              `gitlab-runner register --help`.

              Ones that you probably want to set is

              `CI_SERVER_URL=<CI server URL>`

              `REGISTRATION_TOKEN=<registration secret>`

              WARNING: make sure to use quoted absolute path,
              or it is going to be copied to Nix Store.
            '';
          };
          registrationFlags = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "--docker-helper-image my/gitlab-runner-helper" ];
            description = lib.mdDoc ''
              Extra command-line flags passed to
              `gitlab-runner register`.
              Execute `gitlab-runner register --help`
              for a list of supported flags.
            '';
          };
          environmentVariables = mkOption {
            type = types.attrsOf types.str;
            default = { };
            example = { NAME = "value"; };
            description = lib.mdDoc ''
              Custom environment variables injected to build environment.
              For secrets you can use {option}`registrationConfigFile`
              with `RUNNER_ENV` variable set.
            '';
          };
          description = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Name/description of the runner.
            '';
          };
          executor = mkOption {
            type = types.str;
            default = "docker";
            description = lib.mdDoc ''
              Select executor, eg. shell, docker, etc.
              See [runner documentation](https://docs.gitlab.com/runner/executors/README.html) for more information.
            '';
          };
          buildsDir = mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "/var/lib/gitlab-runner/builds";
            description = lib.mdDoc ''
              Absolute path to a directory where builds will be stored
              in context of selected executor (Locally, Docker, SSH).
            '';
          };
          cloneUrl = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "http://gitlab.example.local";
            description = lib.mdDoc ''
              Overwrite the URL for the GitLab instance. Used if the Runner can’t connect to GitLab on the URL GitLab exposes itself.
            '';
          };
          dockerImage = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              Docker image to be used.
            '';
          };
          dockerVolumes = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "/var/run/docker.sock:/var/run/docker.sock" ];
            description = lib.mdDoc ''
              Bind-mount a volume and create it
              if it doesn't exist prior to mounting.
            '';
          };
          dockerDisableCache = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Disable all container caching.
            '';
          };
          dockerPrivileged = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Give extended privileges to container.
            '';
          };
          dockerExtraHosts = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "other-host:127.0.0.1" ];
            description = lib.mdDoc ''
              Add a custom host-to-IP mapping.
            '';
          };
          dockerAllowedImages = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "ruby:*" "python:*" "php:*" "my.registry.tld:5000/*:*" ];
            description = lib.mdDoc ''
              Whitelist allowed images.
            '';
          };
          dockerAllowedServices = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "postgres:9" "redis:*" "mysql:*" ];
            description = lib.mdDoc ''
              Whitelist allowed services.
            '';
          };
          preCloneScript = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = lib.mdDoc ''
              Runner-specific command script executed before code is pulled.
            '';
          };
          preBuildScript = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = lib.mdDoc ''
              Runner-specific command script executed after code is pulled,
              just before build executes.
            '';
          };
          postBuildScript = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = lib.mdDoc ''
              Runner-specific command script executed after code is pulled
              and just after build executes.
            '';
          };
          tagList = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = lib.mdDoc ''
              Tag list.
            '';
          };
          runUntagged = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              Register to run untagged builds; defaults to
              `true` when {option}`tagList` is empty.
            '';
          };
          limit = mkOption {
            type = types.int;
            default = 0;
            description = lib.mdDoc ''
              Limit how many jobs can be handled concurrently by this service.
              0 (default) simply means don't limit.
            '';
          };
          requestConcurrency = mkOption {
            type = types.int;
            default = 0;
            description = lib.mdDoc ''
              Limit number of concurrent requests for new jobs from GitLab.
            '';
          };
          maximumTimeout = mkOption {
            type = types.int;
            default = 0;
            description = lib.mdDoc ''
              What is the maximum timeout (in seconds) that will be set for
              job when using this Runner. 0 (default) simply means don't limit.
            '';
          };
          protected = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              When set to true Runner will only run on pipelines
              triggered on protected branches.
            '';
          };
          debugTraceDisabled = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              When set to true Runner will disable the possibility of
              using the `CI_DEBUG_TRACE` feature.
            '';
          };
        };
      });
    };
  };
  config = mkIf cfg.enable {
    warnings = (mapAttrsToList
      (n: v: "services.gitlab-runner.services.${n}.`registrationConfigFile` points to a file in Nix Store. You should use quoted absolute path to prevent this.")
      (filterAttrs (n: v: isStorePath v.registrationConfigFile) cfg.services));

    environment.systemPackages = [ cfg.package ];
    systemd.services.gitlab-runner = {
      description = "Gitlab Runner";
      documentation = [ "https://docs.gitlab.com/runner/" ];
      after = [ "network.target" ]
        ++ optional hasDocker "docker.service";
      requires = optional hasDocker "docker.service";
      wantedBy = [ "multi-user.target" ];
      environment = config.networking.proxy.envVars // {
        HOME = "/var/lib/gitlab-runner";
      };
      path = with pkgs; [
        bash
        gawk
        jq
        moreutils
        remarshal
        util-linux
        cfg.package
      ] ++ cfg.extraPackages;
      reloadIfChanged = true;
      serviceConfig = {
        # Set `DynamicUser` under `systemd.services.gitlab-runner.serviceConfig`
        # to `lib.mkForce false` in your configuration to run this service as root.
        # You can also set `User` and `Group` options to run this service as desired user.
        # Make sure to restart service or changes won't apply.
        DynamicUser = true;
        StateDirectory = "gitlab-runner";
        SupplementaryGroups = optional hasDocker "docker";
        ExecStartPre = "!${configureScript}/bin/gitlab-runner-configure";
        ExecStart = "${startScript}/bin/gitlab-runner-start";
        ExecReload = "!${configureScript}/bin/gitlab-runner-configure";
      } // optionalAttrs (cfg.gracefulTermination) {
        TimeoutStopSec = "${cfg.gracefulTimeout}";
        KillSignal = "SIGQUIT";
        KillMode = "process";
      };
    };
    # Enable docker if `docker` executor is used in any service
    virtualisation.docker.enable = mkIf (
      any (s: s.executor == "docker") (attrValues cfg.services)
    ) (mkDefault true);
  };
  imports = [
    (mkRenamedOptionModule [ "services" "gitlab-runner" "packages" ] [ "services" "gitlab-runner" "extraPackages" ] )
    (mkRemovedOptionModule [ "services" "gitlab-runner" "configOptions" ] "Use services.gitlab-runner.services option instead" )
    (mkRemovedOptionModule [ "services" "gitlab-runner" "workDir" ] "You should move contents of workDir (if any) to /var/lib/gitlab-runner" )

    (mkRenamedOptionModule [ "services" "gitlab-runner" "checkInterval" ] [ "services" "gitlab-runner" "settings" "check_interval" ] )
    (mkRenamedOptionModule [ "services" "gitlab-runner" "concurrent" ] [ "services" "gitlab-runner" "settings" "concurrent" ] )
    (mkRenamedOptionModule [ "services" "gitlab-runner" "sentryDSN" ] [ "services" "gitlab-runner" "settings" "sentry_dsn" ] )
    (mkRenamedOptionModule [ "services" "gitlab-runner" "prometheusListenAddress" ] [ "services" "gitlab-runner" "settings" "listen_address" ] )

    (mkRenamedOptionModule [ "services" "gitlab-runner" "sessionServer" "listenAddress" ] [ "services" "gitlab-runner" "settings" "session_server" "listen_address" ] )
    (mkRenamedOptionModule [ "services" "gitlab-runner" "sessionServer" "advertiseAddress" ] [ "services" "gitlab-runner" "settings" "session_server" "advertise_address" ] )
    (mkRenamedOptionModule [ "services" "gitlab-runner" "sessionServer" "sessionTimeout" ] [ "services" "gitlab-runner" "settings" "session_server" "session_timeout" ] )
  ];
}
