{ config, lib, pkgs, ... }:

let
  cfg = config.services.youtrack;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "youtrack" "baseUrl" ] [ "services" "youtrack" "environmentalParameters" "base-url" ])
    (lib.mkRenamedOptionModule [ "services" "youtrack" "port" ] [ "services" "youtrack" "environmentalParameters" "listen-port" ])
    (lib.mkRemovedOptionModule [ "services" "youtrack" "maxMemory" ] "Please instead use `services.youtrack.generalParameters`.")
    (lib.mkRemovedOptionModule [ "services" "youtrack" "maxMetaspaceSize" ] "Please instead use `services.youtrack.generalParameters`.")
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

    extraParams = lib.mkOption {
      default = {};
      description = ''
        Extra parameters to pass to youtrack.
        Use to configure YouTrack 2022.x, deprecated with YouTrack 2023.x. Use `services.youtrack.generalParameters`.
        https://www.jetbrains.com/help/youtrack/standalone/YouTrack-Java-Start-Parameters.html
        for more information.
      '';
      example = lib.literalExpression ''
        {
          "jetbrains.youtrack.overrideRootPassword" = "tortuga";
        }
      '';
      type = lib.types.attrsOf lib.types.str;
      visible = false;
    };

    package = lib.mkOption {
      description = ''
        Package to use.
      '';
      type = lib.types.package;
      default = null;
      relatedPackages = [ "youtrack_2022_3" "youtrack" ];
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

    jvmOpts = lib.mkOption {
      description = ''
        Extra options to pass to the JVM.
        Only has a use with YouTrack 2022.x, deprecated with YouTrack 2023.x. Use `serivces.youtrack.generalParameters`.
        See https://www.jetbrains.com/help/youtrack/standalone/Configure-JVM-Options.html
        for more information.
      '';
      type = lib.types.separatedString " ";
      example = "--J-XX:MetaspaceSize=250m";
      default = "";
      visible = false;
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
        Only has an effect for YouTrack 2023.x.
        See https://www.jetbrains.com/help/youtrack/server/2023.3/youtrack-java-start-parameters.html#general-parameters
        for more information.
      '';
      example = lib.literalExpression ''
        [
          "-Djetbrains.youtrack.admin.restore=true"
          "-Xmx1024m"
        ];
      '';
      default = [];
    };

    environmentalParameters = lib.mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf (oneOf [ int str port ]);
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
        Only has an effect for YouTrack 2023.x.
        See https://www.jetbrains.com/help/youtrack/server/2023.3/youtrack-java-start-parameters.html#environmental-parameters
        for more information.
      '';
      example = lib.literalExpression ''
        {
          secure-mode = "tls";
        }
      '';
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (lib.versions.major cfg.package.version <= "2022")
      "YouTrack 2022.x is deprecated. See https://nixos.org/manual/nixos/unstable/index.html#module-services-youtrack for details on how to upgrade."
    ++ lib.optional (cfg.extraParams != {} && (lib.versions.major cfg.package.version >= "2023"))
      "'services.youtrack.extraParams' is deprecated and has no effect on YouTrack 2023.x and newer. Please migrate to 'services.youtrack.generalParameters'"
    ++ lib.optional (cfg.jvmOpts != "" && (lib.versions.major cfg.package.version >= "2023"))
      "'services.youtrack.jvmOpts' is deprecated and has no effect on YouTrack 2023.x and newer. Please migrate to 'services.youtrack.generalParameters'";

    # XXX: Drop all version feature switches at the point when we consider YT 2022.3 as outdated.
    services.youtrack.package = lib.mkDefault (
      if lib.versionAtLeast config.system.stateVersion "24.11" then pkgs.youtrack
      else pkgs.youtrack_2022_3
    );

    services.youtrack.generalParameters = lib.optional (lib.versions.major cfg.package.version >= "2023")
      "-Ddisable.configuration.wizard.on.upgrade=${lib.boolToString cfg.autoUpgrade}"
      ++ (lib.mapAttrsToList (k: v: "-D${k}=${v}") cfg.extraParams);

    systemd.services.youtrack = let
      service_jar = let
        mergeAttrList = lib.foldl' lib.mergeAttrs {};
        stdParams = mergeAttrList [
          (lib.optionalAttrs (cfg.environmentalParameters ? base-url && cfg.environmentalParameters.base-url != null) {
            "jetbrains.youtrack.baseUrl" = cfg.environmentalParameters.base-url;
          })
          {
          "java.aws.headless" = "true";
          "jetbrains.youtrack.disableBrowser" = "true";
          }
        ];
        extraAttr = lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "-D${k}=${v}") (stdParams // cfg.extraParams));
      in {
        environment.HOME = cfg.statePath;
        environment.YOUTRACK_JVM_OPTS = "${extraAttr}";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [ unixtools.hostname ];
        serviceConfig = {
          Type = "simple";
          User = "youtrack";
          Group = "youtrack";
          Restart = "on-failure";
          ExecStart = ''${cfg.package}/bin/youtrack ${cfg.jvmOpts} ${cfg.environmentalParameters.listen-address}:${toString cfg.environmentalParameters.listen-port}'';
        };
      };
      service_zip = let
        jvmoptions = pkgs.writeTextFile {
          name = "youtrack.jvmoptions";
          text = (lib.concatStringsSep "\n" cfg.generalParameters);
        };

        package = cfg.package.override {
          statePath = cfg.statePath;
        };
      in {
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
          ${package}/bin/youtrack configure ${lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "--${name}=${toString value}") cfg.environmentalParameters )}
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
    in if (lib.versions.major cfg.package.version >= "2023") then service_zip else service_jar;

    users.users.youtrack = {
      description = "Youtrack service user";
      isSystemUser = true;
      home = cfg.statePath;
      createHome = true;
      group = "youtrack";
    };

    users.groups.youtrack = {};

    services.nginx = lib.mkIf (cfg.virtualHost != null) {
      upstreams.youtrack.servers."${cfg.address}:${toString cfg.environmentalParameters.listen-port}" = {};
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
