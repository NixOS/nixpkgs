{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.autokuma;
  monitorDir =
    pkgs.runCommand "autokuma-monitors"
      {
        nativeBuildInputs = [ pkgs.jq ];
        value = builtins.toJSON cfg.staticMonitors;
        passAsFile = [ "value" ];
        preferLocalBuild = true;
      }
      ''
        mkdir $out
        jq -rc "to_entries | .[] | [.key,.value] | .[]" $valuePath | while IFS= read -r filename ; do
          IFS= read -r content
          echo "$content" > "$out/$filename.json"
        done
      '';
  settingsFormat = pkgs.formats.json { };

  inherit (lib) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types)
    attrsOf
    bool
    enum
    int
    lines
    listOf
    nullOr
    path
    str
    submodule
    attrs
    oneOf
    ;
in
{
  options.services.autokuma = {
    enable = mkEnableOption "autokuma";
    package = mkPackageOption pkgs "autokuma" { };

    dockerAddToGroups = mkOption {
      description = "Whether to automaitcally add autokuma user to docker/podman group if docker/podman is enabled.";
      default = true;
      type = bool;
    };
    staticMonitors = mkOption {
      description = ''
        Every element of this list is a file, containing an array of static monitors, see <https://github.com/BigBoot/AutoKuma/blob/master/monitors> for examples.

        For example `{ foo = [ { ... } ]; } is written to a file called `foo.json`, so if one wants to use the first defined item (e. g. group), one needs to use `\"foo[0]\"`.
      '';
      type = attrsOf (listOf attrs);
      default = { };
    };
    settings = mkOption {
      description = ''
        Settings for autokuma, which are passed in a config file.

        Do not set secrets here, use {option}`services.autokuma.environmentFile` instead.
      '';
      type = submodule {
        freeformType = settingsFormat.type;
        options = {
          static_monitors = lib.mkOption {
            type = nullOr path;
            default = null;
            description = ''
              The directory in which static monitor definitions reside.

              Set per default to the static monitor directory generated from {option}`services.autokuma.staticMonitors`, but can be set to a custom directory to supply the configuration files differently.
            '';
          };
          tag_name = mkOption {
            description = "The name of the AutoKuma tag, used to track managed containers";
            default = null;
            type = nullOr str;
            example = "autokuma";
          };
          tag_color = mkOption {
            description = "The color of the AutoKuma tag";
            default = null;
            type = nullOr str;
            example = "#42C0FB";
          };
          default_settings = mkOption {
            description = "Default settings applied to all generated monitors";
            default = "";
            type = lines;
            example = ''
              docker.docker_container: {{container_name}}
              http.max_redirects: 10
              *.max_retries: 3
            '';
          };
          on_delete = mkOption {
            description = "Specify what should happen to a monitor if the autokuma id is not found anymore, either `delete` or `keep`";
            default = "keep";
            type = enum [
              "delete"
              "keep"
            ];
            example = "delete";
          };
          delete_grace_period = mkOption {
            description = "How long to wait in seconds before deleting the entity if the autokuma is not not found anymore (no-op if on_delete is keep)";
            default = 60;
            type = int;
            example = 120;
          };
          insecure_env_access = mkOption {
            description = "Allow access to all env variables in templates, by default only variables starting with `AUTOKUMA__ENV__` can be accessed";
            default = false;
            type = bool;
            example = true;
          };
          snippets = mkOption {
            description = "Define snippets, see https://github.com/BigBoot/AutoKuma/tree/master?tab=readme-ov-file#snippets-";
            default = { };
            type = attrsOf lines;
            example = {
              web = ''
                {{ container_name }}_http.http.name: {{ container_name }}
                {{ container_name }}_http.http.url: https://{{ args[0] }}:{{ args[1] }}
                {{ container_name }}_docker.docker.name: {{ container_name }}_docker
                {{ container_name }}_docker.docker.docker_name: {{ container_name }}
              '';
            };
          };
          kuma = {
            url = mkOption {
              description = "URL of the Uptime-Kuma instance";
              type = nullOr str;
              default = null;
            };
            username = mkOption {
              description = "Username of the Uptime-Kuma instance";
              type = nullOr str;
              default = null;
            };
            password = mkOption {
              description = "Password can not be set in plain text; supply AUTOKUMA__KUMA__PASSWORD using an environment file in {option}`services.autokuma.environmentFile` instead";
              type = enum [ null ];
              default = null;
            };
            mfa_secret = mkOption {
              description = "The MFA secret. Used to generate a tokens for logging into Uptime Kuma (alternative to a single_use mfa_token)";
              default = null;
              type = nullOr str;
              example = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
            };
            headers = mkOption {
              description = "List of HTTP headers to send when connecting to Uptime Kuma";
              default = [ ];
              type = listOf str;
              example = [
                "X-Foo=bar" # Yes, the '=' is not a typo, this is hardcoded at https://github.com/BigBoot/AutoKuma/blob/2fffa28564e37cb846a6aec22d58b56eca8ca25e/kuma-client/src/client.rs#L108
                "X-Bar=baz"
              ];
            };
            connect_timeout = mkOption {
              description = "The timeout for the initial connection to Uptime Kuma in seconds";
              default = 30;
              type = int;
              example = 60;
            };
            call_timeout = mkOption {
              description = "The timeout for executing calls to the Uptime Kuma server";
              default = 30;
              type = int;
              example = 60;
            };
          };
          docker = {
            hosts = mkOption {
              description = "List of Docker hosts; if null will be filled automatically from system docker and podman config";
              default = null;
              type = nullOr (listOf str);
              example = [ "unix:///var/run/docker.sock" ];
            };
            label_prefix = mkOption {
              description = "Prefix used when scanning for container labels";
              default = "kuma";
              type = str;
            };
            source = mkOption {
              description = "Whether monitors should be created from `Containers` or `Services` labels (or `Both`)";
              default = "Containers";
              type = enum [
                "Containers"
                "Services"
                "Both"
              ];
              example = "Services";
            };
            exclude_container_patterns = mkOption {
              description = "Regex patterns to exclude containers by name";
              default = [ ];
              type = listOf str;
              example = [ "^[a-f0-9]{12}_.*_" ];
            };
            tls = {
              verify = mkOption {
                description = "Whether to verify the TLS certificate";
                default = false;
                type = bool;
                example = true;
              };
              cert = mkOption {
                description = "The path to a custom tls certificate in PEM format";
                default = null;
                type = nullOr path;
                example = "/path/to/cert.pem";
              };
            };
          };
          files.follow_symlinks = mkOption {
            description = "Whether AutoKuma should follow symlinks when looking for 'static monitors'";
            default = false;
            type = bool;
            example = true;
          };
        };
      };
      default = { };
    };
    environmentFile = mkOption {
      type = oneOf [
        path
        (listOf path)
      ];
      default = "";
      description = "List of files with environment variables passed to the systemd service, see See {manpage}`systemd.exec(5)` for details on the format.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.autokuma = {
      settings = {
        log_dir = lib.mkDefault "/var/log/autokuma";
        data_path = lib.mkDefault "/var/lib/autokuma";
        docker.hosts = lib.mkDefault (
          lib.optionals config.virtualisation.docker.enable (
            map (
              s: if lib.strings.hasPrefix "/" s then "unix://${s}" else s
            ) config.virtualisation.docker.listenOptions
          )
          ++ lib.optional config.virtualisation.podman.enable "unix:///run/podman/podman.sock"
        );
        static_monitors = lib.mkDefault (if cfg.staticMonitors == { } then null else monitorDir.outPath);
        files.enabled = lib.mkDefault (toString cfg.settings.static_monitors != "");
      };
    };

    systemd.services.autokuma = {
      description = "Autokuma";
      after = [
        "network.target"
      ]
      ++ lib.optionals config.services.uptime-kuma.enable [ "uptime-kuma.service" ];
      wantedBy = [ "multi-user.target" ];
      environment.XDG_CONFIG_HOME =
        pkgs.runCommand "autokuma-config"
          {
            nativeBuildInputs = [ pkgs.jq ];
            value = builtins.toJSON cfg.settings;
            preferLocalBuild = true;
            __structuredAttrs = true;
          }
          ''
            valuePath="$TMPDIR/value"
            printf "%s" "$value" > "$valuePath"
            mkdir -p $out/autokuma
            jq ". | walk(select(. != null))" "$valuePath" > $out/autokuma/config.json
          '';

      serviceConfig = {
        Type = "simple";
        EnvironmentFile = cfg.environmentFile;

        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";

        SupplementaryGroups =
          lib.optionals
            (cfg.settings.docker.enabled && cfg.dockerAddToGroups && config.virtualisation.docker.enable)
            [
              "docker"
            ]
          ++ lib.optionals (
            cfg.settings.docker.enabled && cfg.dockerAddToGroups && config.virtualisation.podman.enable
          ) [ "podman" ];
        DynamicUser = true;
        LogsDirectory = "autokuma";
        StateDirectory = "autokuma";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = false;
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 0027;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    kruemmelspalter
    bartoostveen
  ];
}
