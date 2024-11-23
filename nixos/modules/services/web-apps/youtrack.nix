{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.youtrack;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "youtrack" "baseUrl" ]
      [ "services" "youtrack" "environmentalParameters" "base-url" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "youtrack" "port" ]
      [ "services" "youtrack" "environmentalParameters" "listen-port" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "youtrack"
      "maxMemory"
    ] "Please instead use `services.youtrack.generalParameters`.")
    (lib.mkRemovedOptionModule [
      "services"
      "youtrack"
      "maxMetaspaceSize"
    ] "Please instead use `services.youtrack.generalParameters`.")
    (lib.mkRemovedOptionModule [
      "services"
      "youtrack"
      "extraParams"
    ] "Please migrate to `services.youtrack.generalParameters`.")
    (lib.mkRemovedOptionModule [
      "services"
      "youtrack"
      "jvmOpts"
    ] "Please migrate to `services.youtrack.generalParameters`.")
  ];

  options.services.youtrack = {
    enable = lib.mkEnableOption "YouTrack service";

    address = lib.mkOption {
      description = ''
        The interface youtrack will listen on.
      '';
      default = "127.0.0.1";
      type = lib.types.str;
    };

    package = lib.mkOption {
      description = ''
        Package to use.
      '';
      type = lib.types.package;
      default = pkgs.youtrack;
      defaultText = lib.literalExpression "pkgs.youtrack";
    };

    statePath = lib.mkOption {
      description = ''
        Path were the YouTrack state is stored.
        To this path the base version (e.g. 2023_1) of the used package will be appended.
      '';
      type = lib.types.path;
      default = "/var/lib/youtrack";
    };

    virtualHost = lib.mkOption {
      description = ''
        Name of the nginx virtual host to use and setup.
        If null, do not setup anything.
      '';
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

    autoUpgrade = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether YouTrack should auto upgrade it without showing the upgrade dialog.";
    };

    generalParameters = lib.mkOption {
      type = with lib.types; listOf str;
      description = ''
        General configuration parameters and other JVM options.
        See https://www.jetbrains.com/help/youtrack/server/2023.3/youtrack-java-start-parameters.html#general-parameters
        for more information.
      '';
      example = lib.literalExpression ''
        [
          "-Djetbrains.youtrack.admin.restore=true"
          "-Xmx1024m"
        ];
      '';
      default = [ ];
    };

    environmentalParameters = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            int
            str
            port
          ]);
        options = {
          listen-address = lib.mkOption {
            type = lib.types.str;
            default = "0.0.0.0";
            description = "The interface YouTrack will listen on.";
          };
          listen-port = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = "The port YouTrack will listen on.";
          };
        };
      };
      description = ''
        Environmental configuration parameters, set imperatively. The values doesn't get removed, when removed in Nix.
        See https://www.jetbrains.com/help/youtrack/server/2023.3/youtrack-java-start-parameters.html#environmental-parameters
        for more information.
      '';
      example = lib.literalExpression ''
        {
          secure-mode = "tls";
        }
      '';
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services.youtrack.generalParameters = [
      "-Ddisable.configuration.wizard.on.upgrade=${lib.boolToString cfg.autoUpgrade}"
    ];

    systemd.services.youtrack =
      let
        jvmoptions = pkgs.writeTextFile {
          name = "youtrack.jvmoptions";
          text = (lib.concatStringsSep "\n" cfg.generalParameters);
        };

        package = cfg.package.override {
          statePath = cfg.statePath;
        };
      in
      {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [ unixtools.hostname ];
        preStart = ''
          # This detects old (i.e. <= 2022.3) installations that were not migrated yet
          # and migrates them to the new state directory style
          if [[ -d ${cfg.statePath}/teamsysdata ]] && [[ ! -d ${cfg.statePath}/2022_3 ]]
          then
            mkdir -p ${cfg.statePath}/2022_3
            mv ${cfg.statePath}/teamsysdata ${cfg.statePath}/2022_3
            mv ${cfg.statePath}/.youtrack ${cfg.statePath}/2022_3
          fi
          mkdir -p ${cfg.statePath}/{backups,conf,data,logs,temp}
          ${pkgs.coreutils}/bin/ln -fs ${jvmoptions} ${cfg.statePath}/conf/youtrack.jvmoptions
          ${package}/bin/youtrack configure ${
            lib.concatStringsSep " " (
              lib.mapAttrsToList (name: value: "--${name}=${toString value}") cfg.environmentalParameters
            )
          }
        '';
        serviceConfig = lib.mkMerge [
          {
            Type = "simple";
            User = "youtrack";
            Group = "youtrack";
            Restart = "on-failure";
            ExecStart = "${package}/bin/youtrack run";
          }
          (lib.mkIf (cfg.statePath == "/var/lib/youtrack") {
            StateDirectory = "youtrack";
          })
        ];
      };

    users.users.youtrack = {
      description = "Youtrack service user";
      isSystemUser = true;
      home = cfg.statePath;
      createHome = true;
      group = "youtrack";
    };

    users.groups.youtrack = { };

    services.nginx = lib.mkIf (cfg.virtualHost != null) {
      upstreams.youtrack.servers."${cfg.address}:${toString cfg.environmentalParameters.listen-port}" =
        { };
      virtualHosts.${cfg.virtualHost}.locations = {
        "/" = {
          proxyPass = "http://youtrack";
          extraConfig = ''
            client_max_body_size 10m;
            proxy_http_version 1.1;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };

        "/api/eventSourceBus" = {
          proxyPass = "http://youtrack";
          extraConfig = ''
            proxy_cache off;
            proxy_buffering off;
            proxy_read_timeout 86400s;
            proxy_send_timeout 86400s;
            proxy_set_header Connection "";
            chunked_transfer_encoding off;
            client_max_body_size 10m;
            proxy_http_version 1.1;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };

  meta.doc = ./youtrack.md;
  meta.maintainers = [ lib.maintainers.leona ];
}
