{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.openhab;

  libDir = "/var/lib/openhab";

  fileExt = type:
    if type == "sitemaps" then "sitemap"
    else if type == "transform" then "map"
    else if type == "persistence" then "persist"
    else if type == "services" then "cfg"
    else type;

  filePath = type: name:
    "${type}/${name}.${fileExt type}";

  toText = value:
    if builtins.isList value
    then lib.concatStringsSep "," value
    else if builtins.isBool value
      then if value then "true" else "false"
      else toString value;

  attrsToFile = attrs: name: (pkgs.writeText "openhab-${name}" ''
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (key: val:
      "${key}=${toText val}"
    ) attrs)}
  '');

  cfgDrv = pkgs.stdenv.mkDerivation rec {
    name = "openhab-config";
    buildCommand = ''
      dir=$out/etc/openhab

      # conf/
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (type: items: ''
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (item: contents:
          "install -Dm644 ${pkgs.writeText "${item}.${fileExt type}" contents} $dir/conf/${filePath type item}"
        ) items)}
      '') cfg.configFiles.conf)}

      # conf/services/addons.cfg
      install -Dm644 ${attrsToFile cfg.initialAddons "addons.cfg"} $dir/conf/services/addons.cfg

      # userdata/
      ${lib.concatStringsSep "\n" (map (e:
        "install -Dm644 ${pkgs.writeText (builtins.baseNameOf e.name) e.contents} $dir/userdata/${e.name}"
      ) cfg.configFiles.userData)}
    '';
  };

in {
  meta.maintainers = with maintainers; [ peterhoeg ];

  options.services.openhab = {
    enable = mkEnableOption "OpenHAB - home automation";

    package = mkOption {
      default = pkgs.openhab;
      type = types.package;
      example = literalExample ''
        pkgs.openhab.override {
          withAddons = true;
          addons = with pkgs; [ someLocallyDefinedPackage geoipjava ];
        }
      '';
      description = ''
        OpenHAB package to use with overrides for additional addons.
        </para>
        <para>
        The addons parameter is a list of derivations with their jars in <screen>$out/share/java</screen>.
        </para>
        <para>
        You probably want to override this and least specify the withAddons
        parameter to avoid openHAB having to download a lot of libraries on
        first run.
      '';
    };

    initialAddons = mkOption {
      default = {};
      type = types.attrs;
      example = literalExample ''
        {
          package = "standard";
          remote = true;
          action = [
            "mail"
          ];
          binding = [
            "airquality"
            "exec"
          ];
          misc = [
            "ruleengine"
          ];
          persistence = [
            "influxdb"
          ];
          transformation = [
            "exec"
          ];
          ui = [
            "basic"
            "paper"
          ];
          voice = [
            "picotts"
          ];
      '';
      description = ''
        The various types of addons to install and activate during the first
        run. Refer to the addons.cfg file distributed with openHAB for details.
        </para>
        <para>
        This list is only used on the first run of openHAB.
      '';
    };

    configFiles = {

      conf = mkOption {
        default = {};
        type = types.attrs;
        example = literalExample ''
        {
          services = {
            mail = \'\'
              hostname=smtp.example.com
              from=openHAB <openhab@example.com>
            \'\';

            runtime = \'\'
              org.eclipse.smarthome.inbox:autoApprove=true
              discovery.kodi:background=true
            \'\';
          };

          things = {
            astro = \'\'
              Thing astro:moon:local "Moon" @ "Outside" [geolocation="123,123"]
              Thing astro:sun:local  "Sun" @ "Outside"  [geolocation="123,123"]
            \'\';
          };
        }
        '';
        description = ''
          TODO: document me
        '';
      };

      userData = mkOption {
        default = [];
        type = types.listOf types.attrs;
        example = literalExample ''
        [
          {
            name = "config/org/eclipse/smarthome/core/i18nprovider.config";
            contents = \'\'
              service.pid="org.eclipse.smarthome.core.i18nprovider"
              language="en"
              location="123.123,123.123"
              region="DK"
              timezone="''${config.time.timeZone}"
            \'\';
          }
        ]
        '';
        description = ''
          TODO: document me
        '';
      };
    };

    java = {
      package = mkOption {
        default = pkgs.jre8;
        example = "pkgs.oraclejdk8";
        type = types.package;
        description = ''
          By default we are using OpenJDK as the Java run-time due to it being
          open source, but if you want to connect to an instance of OpenHAB
          cloud either self-hosted with Let's Encrypt certificates or
          myopenhab.org, you <emphasis>will</emphasis> need the Oracle JRE
          instead due to OpenJDK missing support for various encryption
          providers.
        '';
      };

      elevatePermissions = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Some bindings will require the java process to have additional
          permissions. Enabling this will configure a wrapper that does that.
        '';
      };

      additionalArguments = mkOption {
        default = [];
        type = types.listOf types.str;
        description = ''
          Additional arguments to pass to the java process.
        '';
      };
    };

    ports = {
      http = mkOption {
        default = 8080;
        type = types.port;
        description = "The port on which to listen for HTTP.";
      };

      https = mkOption {
        default = 8443;
        type = types.port;
        description = "The port on which to listen for HTTPS.";
      };
    };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified ports.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall (with cfg.ports; [ http https ]);

    security.wrappers = lib.mkIf cfg.java.elevatePermissions {
      java = {
        source = "${cfg.java.package}/bin/java";
        capabilities = "cap_net_raw,cap_net_admin=+eip cap_net_bind_service=+ep";
      };
    };

    systemd.services = let
      documentation = [
        https://www.openhab.org/docs/
        https://community.openhab.org
      ];

      environment = {
        JAVA = if cfg.java.elevatePermissions
          then "/run/wrappers/bin/java" # we need to make sure that we use the wrapper
          else "${cfg.java.package}/bin/java";
        JAVA_HOME = cfg.java.package;
        JAVA_OPTS = lib.concatStringsSep " " cfg.java.additionalArguments;
        KARAF_EXEC = "exec"; # upstream's launcher script doesn't use exec
                             # unless running in daemon mode so we force it here
        OPENHAB_CONF = "${libDir}/conf";
        OPENHAB_USERDATA = "${libDir}/userdata";
        OPENHAB_HTTP_PORT = toString cfg.ports.http;
        OPENHAB_HTTPS_PORT = toString cfg.ports.https;
      };

      wantedBy = [ "multi-user.target" ];

      dirName = builtins.baseNameOf libDir;

      commonServiceConfig = {
        DynamicUser = true;
        User = "openhab";
        Group = "openhab";
        PrivateTmp = true;
        ProtectHome = "tmpfs";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        CacheDirectory = dirName;
        LogsDirectory  = dirName;
        StateDirectory = dirName;
        WorkingDirectory = libDir;
      };

    in {
      openhab-setup = rec {
        description = "openHAB - copy and link config files into place";
        inherit documentation environment wantedBy;
        script = ''
          set -euo pipefail

          args=(--no-preserve=mode --remove-destination -R)

          wipe_config() {
            rm -rf ${libDir}/.reset \
              $OPENHAB_CONF \
              $OPENHAB_USERDATA
          }

          wipe_cache() {
            rm -rf ${libDir}/.reset_cache \
              /var/cache/${dirName}/* \
              $OPENHAB_USERDATA/tmp/*
          }

          if [ -f ${libDir}/.reset ]; then
            wipe_config
            wipe_cache
          fi

          if [ -f ${libDir}/.reset_cache ]; then
            wipe_cache
          fi

          # Copy in default configuration
          if [ ! -d $OPENHAB_CONF ]; then
            cp ''${args[@]} ${cfg.package}/share/openhab/conf $OPENHAB_CONF
          fi

          if [ ! -d $OPENHAB_USERDATA ]; then
            cp ''${args[@]} ${cfg.package}/share/openhab/userdata $OPENHAB_USERDATA
          fi

          rm -rf $OPENHAB_USERDATA/cache
          ln -s /var/cache/${dirName} $OPENHAB_USERDATA/cache

          # recursively copy and symlink files into place
          cp ''${args[@]} -sf ${cfgDrv}/etc/openhab/* ${libDir}/
        '';

        serviceConfig = commonServiceConfig // {
          Type = "oneshot";
          PrivateDevices = true;
          PrivateNetwork = true;
        };
      };

      openhab = rec {
        description = "openHAB - empowering the smart home";
        inherit documentation environment wantedBy;
        wants = [ "network-online.target" ];
        requires = [ "openhab-setup.service" ];
        after = wants ++ requires;
        path = [
          "/run/wrappers"
          cfg.java.package
        ];

        serviceConfig = commonServiceConfig // {
          Type = if (lib.versionAtLeast pkgs.systemd.version "240")
                 then "exec"
                 else "simple";
          SupplementaryGroups = [ "audio" "dialout" "tty" ];
          AmbientCapabilities = [
            "CAP_NET_ADMIN"
            "CAP_NET_BIND_SERVICE"
            "CAP_NET_RAW"
          ];
          ExecStart = "${cfg.package}/bin/openhab run";
          ExecStop = "${cfg.package}/bin/openhab stop";
          SuccessExitStatus="0 143";
          RestartSec = "5s";
          Restart = "on-failure";
          TimeoutStopSec = "120";
          LimitNOFILE = "102642";
        };
      };
    };
  };
}
