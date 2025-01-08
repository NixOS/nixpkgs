{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (builtins)
    hashString
    map
    substring
    toJSON
    toString
    unsafeDiscardStringContext
    ;

  inherit (lib)
    any
    assertMsg
    attrValues
    concatStringsSep
    escapeShellArg
    filterAttrs
    hasPrefix
    isStorePath
    literalExpression
    mapAttrs'
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    lib.mkOption
    mkPackageOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    nameValuePair
    lib.optional
    lib.optionalAttrs
    lib.optionals
    teams
    toShellVar
    types
    ;

  cfg = config.services.gitlab-runner;
  hasDocker = config.virtualisation.docker.enable;
  hasPodman = config.virtualisation.podman.enable && config.virtualisation.podman.dockerSocket.enable;

  /*
    The whole logic of this module is to diff the hashes of the desired vs existing runners
    The hash is recorded in the runner's name because we can't do better yet
    See https://gitlab.com/gitlab-org/gitlab-runner/-/issues/29350 for more details
  */
  genRunnerName =
    name: service:
    let
      hash = substring 0 12 (hashString "md5" (unsafeDiscardStringContext (toJSON service)));
    in
    if service ? description && service.description != null then
      "${hash} ${service.description}"
    else
      "${name}_${config.networking.hostName}_${hash}";

  hashedServices = mapAttrs' (
    name: service: nameValuePair (genRunnerName name service) service
  ) cfg.services;
  configPath = ''"$HOME"/.gitlab-runner/config.toml'';
  configureScript = pkgs.writeShellApplication {
    name = "gitlab-runner-configure";
    runtimeInputs =
      [ cfg.package ]
      ++ (with pkgs; [
        bash
        gawk
        jq
        moreutils
        remarshal
        util-linux
        perl
        python3
      ]);
    text =
      if (cfg.configFile != null) then
        ''
          cp ${cfg.configFile} ${configPath}
          # make config file readable by service
          chown -R --reference="$HOME" "$(dirname ${configPath})"
        ''
      else
        ''
          export CONFIG_FILE=${configPath}

          mkdir -p "$(dirname ${configPath})"
          touch ${configPath}

          # update global options
          remarshal --if toml --of json --stringify ${configPath} \
            | jq -cM 'with_entries(select([.key] | inside(["runners"])))' \
            | jq -scM '.[0] + .[1]' - <(echo ${lib.escapeShellArg (toJSON cfg.settings)}) \
            | remarshal --if json --of toml \
            | sponge ${configPath}

          # remove no longer existing services
          gitlab-runner verify --delete

          ${toShellVar "NEEDED_SERVICES" (lib.mapAttrs (name: value: 1) hashedServices)}

          declare -A REGISTERED_SERVICES

          while IFS="," read -r name token;
          do
            REGISTERED_SERVICES["$name"]="$token"
          done < <(gitlab-runner --log-format json list 2>&1 | grep Token  | jq -r '.msg +"," + .Token')

          echo "NEEDED_SERVICES: " "''${!NEEDED_SERVICES[@]}"
          echo "REGISTERED_SERVICES:" "''${!REGISTERED_SERVICES[@]}"

          # difference between current and desired state
          declare -A NEW_SERVICES
          for name in "''${!NEEDED_SERVICES[@]}"; do
            if [ ! -v 'REGISTERED_SERVICES[$name]' ]; then
              NEW_SERVICES[$name]=1
            fi
          done

          declare -A OLD_SERVICES
          # shellcheck disable=SC2034
          for name in "''${!REGISTERED_SERVICES[@]}"; do
            if [ ! -v 'NEEDED_SERVICES[$name]' ]; then
              OLD_SERVICES[$name]=1
            fi
          done

          # register new services
          ${lib.concatStringsSep "\n" (
            mapAttrsToList (name: service: ''
              # TODO so here we should mention NEW_SERVICES
              if [ -v 'NEW_SERVICES["${name}"]' ] ; then
                bash -c ${
                  escapeShellArg (
                    concatStringsSep " \\\n " (
                      [
                        "set -a && source ${
                          if service.registrationConfigFile != null then
                            service.registrationConfigFile
                          else
                            service.authenticationTokenConfigFile
                        } &&"
                        "gitlab-runner register"
                        "--non-interactive"
                        "--name '${name}'"
                        "--executor ${service.executor}"
                        "--limit ${toString service.limit}"
                        "--request-concurrency ${toString service.requestConcurrency}"
                      ]
                      ++ lib.optional (
                        service.authenticationTokenConfigFile == null
                      ) "--maximum-timeout ${toString service.maximumTimeout}"
                      ++ service.registrationFlags
                      ++ lib.optional (service.buildsDir != null) "--builds-dir ${service.buildsDir}"
                      ++ lib.optional (service.cloneUrl != null) "--clone-url ${service.cloneUrl}"
                      ++ lib.optional (
                        service.preGetSourcesScript != null
                      ) "--pre-get-sources-script ${service.preGetSourcesScript}"
                      ++ lib.optional (
                        service.postGetSourcesScript != null
                      ) "--post-get-sources-script ${service.postGetSourcesScript}"
                      ++ lib.optional (service.preBuildScript != null) "--pre-build-script ${service.preBuildScript}"
                      ++ lib.optional (service.postBuildScript != null) "--post-build-script ${service.postBuildScript}"
                      ++ lib.optional (
                        service.authenticationTokenConfigFile == null && service.tagList != [ ]
                      ) "--tag-list ${lib.concatStringsSep "," service.tagList}"
                      ++ lib.optional (service.authenticationTokenConfigFile == null && service.runUntagged) "--run-untagged"
                      ++ lib.optional (
                        service.authenticationTokenConfigFile == null && service.protected
                      ) "--access-level ref_protected"
                      ++ lib.optional service.debugTraceDisabled "--debug-trace-disabled"
                      ++ map (e: "--env ${lib.escapeShellArg e}") (
                        mapAttrsToList (name: value: "${name}=${value}") service.environmentVariables
                      )
                      ++ lib.optionals (hasPrefix "docker" service.executor) (
                        assert (
                          assertMsg (
                            service.dockerImage != null
                          ) "dockerImage option is required for ${service.executor} executor (${name})"
                        );
                        [ "--docker-image ${service.dockerImage}" ]
                        ++ lib.optional service.dockerDisableCache "--docker-disable-cache"
                        ++ lib.optional service.dockerPrivileged "--docker-privileged"
                        ++ map (v: "--docker-volumes ${lib.escapeShellArg v}") service.dockerVolumes
                        ++ map (v: "--docker-extra-hosts ${lib.escapeShellArg v}") service.dockerExtraHosts
                        ++ map (v: "--docker-allowed-images ${lib.escapeShellArg v}") service.dockerAllowedImages
                        ++ map (v: "--docker-allowed-services ${lib.escapeShellArg v}") service.dockerAllowedServices
                      )
                    )
                  )
                } && sleep 1 || exit 1
              fi
            '') hashedServices
          )}

          # check key is in array https://stackoverflow.com/questions/30353951/how-to-check-if-dictionary-contains-a-key-in-bash

          echo "NEW_SERVICES: ''${NEW_SERVICES[*]}"
          echo "OLD_SERVICES: ''${OLD_SERVICES[*]}"
          # unregister old services
          for NAME in "''${!OLD_SERVICES[@]}"
          do
            [ -n "$NAME" ] && gitlab-runner unregister \
              --name "$NAME" && sleep 1
          done

          # make config file readable by service
          chown -R --reference="$HOME" "$(dirname ${configPath})"
        '';
  };
  startScript = pkgs.writeShellScriptBin "gitlab-runner-start" ''
    export CONFIG_FILE=${configPath}
    exec gitlab-runner run --working-directory $HOME
  '';
in
{
  options.services.gitlab-runner = {
    enable = lib.mkEnableOption "Gitlab Runner";
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Configuration file for gitlab-runner.

        {option}`configFile` takes precedence over {option}`services`.
        {option}`checkInterval` and {option}`concurrent` will be ignored too.

        This option is deprecated, please use {option}`services` instead.
        You can use {option}`registrationConfigFile` and
        {option}`registrationFlags`
        for settings not covered by this module.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = (pkgs.formats.json { }).type;
      };
      default = { };
      description = ''
        Global gitlab-runner configuration. See
        <https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-global-section>
        for supported values.
      '';
    };
    gracefulTermination = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Finish all remaining jobs before stopping.
        If not set gitlab-runner will stop immediately without waiting
        for jobs to finish, which will lead to failed builds.
      '';
    };
    gracefulTimeout = lib.mkOption {
      type = lib.types.str;
      default = "infinity";
      example = "5min 20s";
      description = ''
        Time to wait until a graceful shutdown is turned into a forceful one.
      '';
    };
    package = lib.mkPackageOption pkgs "gitlab-runner" {
      example = "gitlab-runner_1_11";
    };
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Extra packages to add to PATH for the gitlab-runner process.
      '';
    };
    services = lib.mkOption {
      description = "GitLab Runner services.";
      default = { };
      example = lib.literalExpression ''
        {
          # runner for building in docker via host's nix-daemon
          # nix store will be readable in runner, might be insecure
          nix = {
            # File should contain at least these two variables:
            # - `CI_SERVER_URL`
            # - `REGISTRATION_TOKEN`
            #
            # NOTE: Support for runner registration tokens will be removed in GitLab 18.0.
            # Please migrate to runner authentication tokens soon. For reference, the example
            # runners below this one are configured with authentication tokens instead.
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

              ''${pkgs.nix}/bin/nix-env -i ''${lib.concatStringsSep " " (with pkgs; [ nix cacert git openssh ])}

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
            # `CI_SERVER_TOKEN`
            authenticationTokenConfigFile = "/run/secrets/gitlab-runner-docker-images-token-env";

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
            # `CI_SERVER_TOKEN`
            authenticationTokenConfigFile = "/run/secrets/gitlab-runner-shell-token-env";

            executor = "shell";
            tagList = [ "shell" ];
          };
          # runner for everything else
          default = {
            # File should contain at least these two variables:
            # `CI_SERVER_URL`
            # `CI_SERVER_TOKEN`
            authenticationTokenConfigFile = "/run/secrets/gitlab-runner-default-token-env";
            dockerImage = "debian:stable";
          };
        }
      '';
      type = lib.types.attrsOf (
        types.submodule {
          options = {
            authenticationTokenConfigFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                Absolute path to a file containing environment variables used for
                gitlab-runner registrations with *runner authentication tokens*.
                They replace the deprecated *runner registration tokens*, as
                outlined in the [GitLab documentation].

                A list of all supported environment variables can be found with
                `gitlab-runner register --help`.

                The ones you probably want to set are:
                - `CI_SERVER_URL=<CI server URL>`
                - `CI_SERVER_TOKEN=<runner authentication token secret>`

                ::: {.warning}
                Make sure to use a quoted absolute path,
                or it is going to be copied to Nix Store.
                :::

                [GitLab documentation]: https://docs.gitlab.com/17.0/ee/ci/runners/new_creation_workflow.html#estimated-time-frame-for-planned-changes
              '';
            };
            registrationConfigFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                Absolute path to a file with environment variables
                used for gitlab-runner registration with *runner registration
                tokens*.

                A list of all supported environment variables can be found in
                `gitlab-runner register --help`.

                The ones you probably want to set are:
                - `CI_SERVER_URL=<CI server URL>`
                - `REGISTRATION_TOKEN=<registration secret>`

                Support for *runner registration tokens* is deprecated since
                GitLab 16.0, has been disabled by default in GitLab 17.0 and
                will be removed in GitLab 18.0, as outlined in the
                [GitLab documentation]. Please consider migrating to
                [runner authentication tokens] and check the documentation on
                {option}`services.gitlab-runner.services.<name>.authenticationTokenConfigFile`.

                ::: {.warning}
                Make sure to use a quoted absolute path,
                or it is going to be copied to Nix Store.
                :::

                [GitLab documentation]: https://docs.gitlab.com/17.0/ee/ci/runners/new_creation_workflow.html#estimated-time-frame-for-planned-changes
                [runner authentication tokens]: https://docs.gitlab.com/17.0/ee/ci/runners/new_creation_workflow.html#the-new-runner-registration-workflow
              '';
            };
            registrationFlags = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = [ "--docker-helper-image my/gitlab-runner-helper" ];
              description = ''
                Extra command-line flags passed to
                `gitlab-runner register`.
                Execute `gitlab-runner register --help`
                for a list of supported flags.
              '';
            };
            environmentVariables = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              default = { };
              example = {
                NAME = "value";
              };
              description = ''
                Custom environment variables injected to build environment.
                For secrets you can use {option}`registrationConfigFile`
                with `RUNNER_ENV` variable set.
              '';
            };
            description = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Name/description of the runner.
              '';
            };
            executor = lib.mkOption {
              type = lib.types.str;
              default = "docker";
              description = ''
                Select executor, eg. shell, docker, etc.
                See [runner documentation](https://docs.gitlab.com/runner/executors/README.html) for more information.
              '';
            };
            buildsDir = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
              example = "/var/lib/gitlab-runner/builds";
              description = ''
                Absolute path to a directory where builds will be stored
                in context of selected executor (Locally, Docker, SSH).
              '';
            };
            cloneUrl = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "http://gitlab.example.local";
              description = ''
                Overwrite the URL for the GitLab instance. Used if the Runner can’t connect to GitLab on the URL GitLab exposes itself.
              '';
            };
            dockerImage = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Docker image to be used.
              '';
            };
            dockerVolumes = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = [ "/var/run/docker.sock:/var/run/docker.sock" ];
              description = ''
                Bind-mount a volume and create it
                if it doesn't exist prior to mounting.
              '';
            };
            dockerDisableCache = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Disable all container caching.
              '';
            };
            dockerPrivileged = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Give extended privileges to container.
              '';
            };
            dockerExtraHosts = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = [ "other-host:127.0.0.1" ];
              description = ''
                Add a custom host-to-IP mapping.
              '';
            };
            dockerAllowedImages = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = [
                "ruby:*"
                "python:*"
                "php:*"
                "my.registry.tld:5000/*:*"
              ];
              description = ''
                Whitelist allowed images.
              '';
            };
            dockerAllowedServices = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = [
                "postgres:9"
                "redis:*"
                "mysql:*"
              ];
              description = ''
                Whitelist allowed services.
              '';
            };
            preGetSourcesScript = lib.mkOption {
              type = lib.types.nullOr (types.either types.str types.path);
              default = null;
              description = ''
                Runner-specific command script executed before code is pulled.
              '';
            };
            postGetSourcesScript = lib.mkOption {
              type = lib.types.nullOr (types.either types.str types.path);
              default = null;
              description = ''
                Runner-specific command script executed after code is pulled.
              '';
            };
            preBuildScript = lib.mkOption {
              type = lib.types.nullOr (types.either types.str types.path);
              default = null;
              description = ''
                Runner-specific command script executed after code is pulled,
                just before build executes.
              '';
            };
            postBuildScript = lib.mkOption {
              type = lib.types.nullOr (types.either types.str types.path);
              default = null;
              description = ''
                Runner-specific command script executed after code is pulled
                and just after build executes.
              '';
            };
            tagList = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = ''
                Tag list.

                This option has no effect for runners registered with an runner
                authentication tokens and will be ignored.
              '';
            };
            runUntagged = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Register to run untagged builds; defaults to
                `true` when {option}`tagList` is empty.

                This option has no effect for runners registered with an runner
                authentication tokens and will be ignored.
              '';
            };
            limit = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = ''
                Limit how many jobs can be handled concurrently by this service.
                0 (default) simply means don't limit.
              '';
            };
            requestConcurrency = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = ''
                Limit number of concurrent requests for new jobs from GitLab.
              '';
            };
            maximumTimeout = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = ''
                What is the maximum timeout (in seconds) that will be set for
                job when using this Runner. 0 (default) simply means don't limit.

                This option has no effect for runners registered with an runner
                authentication tokens and will be ignored.
              '';
            };
            protected = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                When set to true Runner will only run on pipelines
                triggered on protected branches.

                This option has no effect for runners registered with an runner
                authentication tokens and will be ignored.
              '';
            };
            debugTraceDisabled = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                When set to true Runner will disable the possibility of
                using the `CI_DEBUG_TRACE` feature.
              '';
            };
          };
        }
      );
    };
    clear-docker-cache = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to periodically prune gitlab runner's Docker resources. If
          enabled, a systemd timer will run {command}`clear-docker-cache` as
          specified by the `dates` option.
        '';
      };

      flags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "prune" ];
        description = ''
          Any additional flags passed to {command}`clear-docker-cache`.
        '';
      };

      dates = lib.mkOption {
        default = "weekly";
        type = lib.types.str;
        description = ''
          Specification (in the format described by
          {manpage}`systemd.time(7)`) of the time at
          which the prune will occur.
        '';
      };

      package = lib.mkOption {
        default = config.virtualisation.docker.package;
        defaultText = lib.literalExpression "config.virtualisation.docker.package";
        example = lib.literalExpression "pkgs.docker";
        description = "Docker package to use for clearing up docker cache.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = mapAttrsToList (name: serviceConfig: {
      assertion =
        serviceConfig.registrationConfigFile == null || serviceConfig.authenticationTokenConfigFile == null;
      message = "`services.gitlab-runner.${name}.registrationConfigFile` and `services.gitlab-runner.services.${name}.authenticationTokenConfigFile` are mutually exclusive.";
    }) cfg.services;

    warnings =
      mapAttrsToList (
        name: serviceConfig:
        "services.gitlab-runner.services.${name}.`registrationConfigFile` points to a file in Nix Store. You should use quoted absolute path to prevent this."
      ) (lib.filterAttrs (name: serviceConfig: isStorePath serviceConfig.registrationConfigFile) cfg.services)
      ++
        mapAttrsToList
          (
            name: serviceConfig:
            "services.gitlab-runner.services.${name}.`authenticationTokenConfigFile` points to a file in Nix Store. You should use quoted absolute path to prevent this."
          )
          (
            filterAttrs (
              name: serviceConfig: isStorePath serviceConfig.authenticationTokenConfigFile
            ) cfg.services
          )
      ++
        mapAttrsToList
          (name: serviceConfig: ''
            Runner registration tokens have been deprecated and disabled by default in GitLab >= 17.0.
            Consider migrating to runner authentication tokens by setting `services.gitlab-runner.services.${name}.authenticationTokenConfigFile`.
            https://docs.gitlab.com/17.0/ee/ci/runners/new_creation_workflow.html'')
          (
            filterAttrs (name: serviceConfig: serviceConfig.authenticationTokenConfigFile == null) cfg.services
          )
      ++
        mapAttrsToList
          (
            name: serviceConfig:
            ''`services.gitlab-runner.services.${name}.protected` with runner authentication tokens has no effect and will be ignored. Please remove it from your configuration.''
          )
          (
            filterAttrs (
              name: serviceConfig:
              serviceConfig.authenticationTokenConfigFile != null && serviceConfig.protected == true
            ) cfg.services
          )
      ++
        mapAttrsToList
          (
            name: serviceConfig:
            ''`services.gitlab-runner.services.${name}.runUntagged` with runner authentication tokens has no effect and will be ignored. Please remove it from your configuration.''
          )
          (
            filterAttrs (
              name: serviceConfig:
              serviceConfig.authenticationTokenConfigFile != null && serviceConfig.runUntagged == true
            ) cfg.services
          )
      ++
        mapAttrsToList
          (
            name: v:
            ''`services.gitlab-runner.services.${name}.maximumTimeout` with runner authentication tokens has no effect and will be ignored. Please remove it from your configuration.''
          )
          (
            filterAttrs (
              name: serviceConfig:
              serviceConfig.authenticationTokenConfigFile != null && serviceConfig.maximumTimeout != 0
            ) cfg.services
          )
      ++
        mapAttrsToList
          (
            name: v:
            ''`services.gitlab-runner.services.${name}.tagList` with runner authentication tokens has no effect and will be ignored. Please remove it from your configuration.''
          )
          (
            filterAttrs (
              serviceName: serviceConfig:
              serviceConfig.authenticationTokenConfigFile != null && serviceConfig.tagList != [ ]
            ) cfg.services
          );

    environment.systemPackages = [ cfg.package ];
    systemd.services.gitlab-runner = {
      description = "Gitlab Runner";
      documentation = [ "https://docs.gitlab.com/runner/" ];
      after =
        [ "network.target" ] ++ lib.optional hasDocker "docker.service" ++ lib.optional hasPodman "podman.service";

      requires = lib.optional hasDocker "docker.service" ++ lib.optional hasPodman "podman.service";
      wantedBy = [ "multi-user.target" ];
      environment = config.networking.proxy.envVars // {
        HOME = "/var/lib/gitlab-runner";
      };

      path =
        (with pkgs; [
          bash
          gawk
          jq
          moreutils
          remarshal
          util-linux
        ])
        ++ [ cfg.package ]
        ++ cfg.extraPackages;

      reloadIfChanged = true;
      serviceConfig =
        {
          # Set `DynamicUser` under `systemd.services.gitlab-runner.serviceConfig`
          # to `lib.mkForce false` in your configuration to run this service as root.
          # You can also set `User` and `Group` options to run this service as desired user.
          # Make sure to restart service or changes won't apply.
          DynamicUser = true;
          StateDirectory = "gitlab-runner";
          SupplementaryGroups = lib.optional hasDocker "docker" ++ lib.optional hasPodman "podman";
          ExecStartPre = "!${configureScript}/bin/gitlab-runner-configure";
          ExecStart = "${startScript}/bin/gitlab-runner-start";
          ExecReload = "!${configureScript}/bin/gitlab-runner-configure";
        }
        // lib.optionalAttrs cfg.gracefulTermination {
          TimeoutStopSec = "${cfg.gracefulTimeout}";
          KillSignal = "SIGQUIT";
          KillMode = "process";
        };
    };
    # Enable periodic clear-docker-cache script
    systemd.services.gitlab-runner-clear-docker-cache =
      mkIf (cfg.clear-docker-cache.enable && (any (s: s.executor == "docker") (lib.attrValues cfg.services)))
        {
          description = "Prune gitlab-runner docker resources";
          restartIfChanged = false;
          unitConfig.X-StopOnRemoval = false;

          serviceConfig.Type = "oneshot";

          path = [
            cfg.clear-docker-cache.package
            pkgs.gawk
          ];

          script = ''
            ${pkgs.gitlab-runner}/bin/clear-docker-cache ${toString cfg.clear-docker-cache.flags}
          '';

          startAt = cfg.clear-docker-cache.dates;
        };
    # Enable docker if `docker` executor is used in any service
    virtualisation.docker.enable = lib.mkIf (any (s: s.executor == "docker") (lib.attrValues cfg.services)) (
      mkDefault true
    );
  };
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "gitlab-runner" "packages" ]
      [ "services" "gitlab-runner" "extraPackages" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "gitlab-runner"
      "configOptions"
    ] "Use services.gitlab-runner.services option instead")
    (lib.mkRemovedOptionModule [
      "services"
      "gitlab-runner"
      "workDir"
    ] "You should move contents of workDir (if any) to /var/lib/gitlab-runner")

    (lib.mkRenamedOptionModule
      [ "services" "gitlab-runner" "checkInterval" ]
      [ "services" "gitlab-runner" "settings" "check_interval" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitlab-runner" "concurrent" ]
      [ "services" "gitlab-runner" "settings" "concurrent" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitlab-runner" "sentryDSN" ]
      [ "services" "gitlab-runner" "settings" "sentry_dsn" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitlab-runner" "prometheusListenAddress" ]
      [ "services" "gitlab-runner" "settings" "listen_address" ]
    )

    (lib.mkRenamedOptionModule
      [ "services" "gitlab-runner" "sessionServer" "listenAddress" ]
      [ "services" "gitlab-runner" "settings" "session_server" "listen_address" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitlab-runner" "sessionServer" "advertiseAddress" ]
      [ "services" "gitlab-runner" "settings" "session_server" "advertise_address" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitlab-runner" "sessionServer" "sessionTimeout" ]
      [ "services" "gitlab-runner" "settings" "session_server" "session_timeout" ]
    )
  ];

  meta.maintainers = lib.teams.gitlab.members;
}
