{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.gerrit;

  # NixOS option type for git-like configs
  gitIniType = with types;
    let
      primitiveType = either str (either bool int);
      multipleType = either primitiveType (listOf primitiveType);
      sectionType = lazyAttrsOf multipleType;
      supersectionType = lazyAttrsOf (either multipleType sectionType);
    in lazyAttrsOf supersectionType;

  gerritConfig = pkgs.writeText "gerrit.conf" (
    lib.generators.toGitINI cfg.settings
  );

  replicationConfig = pkgs.writeText "replication.conf" (
    lib.generators.toGitINI cfg.replicationSettings
  );

  # Wrap the gerrit java with all the java options so it can be called
  # like a normal CLI app
  gerrit-cli = pkgs.writeShellScriptBin "gerrit" ''
    set -euo pipefail
    jvmOpts=(
      ${lib.escapeShellArgs cfg.jvmOpts}
      -Xmx${cfg.jvmHeapLimit}
    )
    exec ${cfg.jvmPackage}/bin/java \
      "''${jvmOpts[@]}" \
      -jar ${cfg.package}/webapps/${cfg.package.name}.war \
      "$@"
  '';

  gerrit-plugins = pkgs.runCommand
    "gerrit-plugins"
    {
      buildInputs = [ gerrit-cli ];
    }
    ''
      shopt -s nullglob
      mkdir $out

      for name in ${toString cfg.builtinPlugins}; do
        echo "Installing builtin plugin $name.jar"
        gerrit cat plugins/$name.jar > $out/$name.jar
      done

      for file in ${toString cfg.plugins}; do
        name=$(echo "$file" | cut -d - -f 2-)
        echo "Installing plugin $name"
        ln -sf "$file" $out/$name
      done
    '';
in
{
  options = {
    services.gerrit = {
      enable = mkEnableOption "Gerrit service";

      package = mkPackageOption pkgs "gerrit" { };

      jvmPackage = mkPackageOption pkgs "jre_headless" { };

      jvmOpts = mkOption {
        type = types.listOf types.str;
        default = [
          "-Dflogger.backend_factory=com.google.common.flogger.backend.log4j.Log4jBackendFactory#getInstance"
          "-Dflogger.logging_context=com.google.gerrit.server.logging.LoggingContext#getInstance"
        ];
        description = "A list of JVM options to start gerrit with.";
      };

      jvmHeapLimit = mkOption {
        type = types.str;
        default = "1024m";
        description = ''
          How much memory to allocate to the JVM heap
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "[::]:8080";
        description = ''
          `hostname:port` to listen for HTTP traffic.

          This is bound using the systemd socket activation.
        '';
      };

      settings = mkOption {
        type = gitIniType;
        default = {};
        description = ''
          Gerrit configuration. This will be generated to the
          `etc/gerrit.config` file.
        '';
      };

      replicationSettings = mkOption {
        type = gitIniType;
        default = {};
        description = ''
          Replication configuration. This will be generated to the
          `etc/replication.config` file.
        '';
      };

      plugins = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          List of plugins to add to Gerrit. Each derivation is a jar file
          itself where the name of the derivation is the name of plugin.
        '';
      };

      builtinPlugins = mkOption {
        type = types.listOf (types.enum cfg.package.passthru.plugins);
        default = [];
        description = ''
          List of builtins plugins to install. Those are shipped in the
          `gerrit.war` file.
        '';
      };

      serverId = mkOption {
        type = types.str;
        description = ''
          Set a UUID that uniquely identifies the server.

          This can be generated with
          `nix-shell -p util-linux --run uuidgen`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.replicationSettings != {} -> elem "replication" cfg.builtinPlugins;
        message = "Gerrit replicationSettings require enabling the replication plugin";
      }
    ];

    services.gerrit.settings = {
      cache.directory = "/var/cache/gerrit";
      container.heapLimit = cfg.jvmHeapLimit;
      gerrit.basePath = lib.mkDefault "git";
      gerrit.serverId = cfg.serverId;
      httpd.inheritChannel = "true";
      httpd.listenUrl = lib.mkDefault "http://${cfg.listenAddress}";
      index.type = lib.mkDefault "lucene";
    };

    # Add the gerrit CLI to the system to run `gerrit init` and friends.
    environment.systemPackages = [ gerrit-cli ];

    systemd.sockets.gerrit = {
      unitConfig.Description = "Gerrit HTTP socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ cfg.listenAddress ];
    };

    systemd.services.gerrit = {
      description = "Gerrit";

      wantedBy = [ "multi-user.target" ];
      requires = [ "gerrit.socket" ];
      after = [ "gerrit.socket" "network.target" ];

      path = [
        gerrit-cli
        pkgs.bash
        pkgs.coreutils
        pkgs.git
        pkgs.openssh
      ];

      environment = {
        GERRIT_HOME = "%S/gerrit";
        GERRIT_TMP = "%T";
        HOME = "%S/gerrit";
        XDG_CONFIG_HOME = "%S/gerrit/.config";
      };

      preStart = ''
        set -euo pipefail

        # bootstrap if nothing exists
        if [[ ! -d git ]]; then
          gerrit init --batch --no-auto-start
        fi

        # install gerrit.war for the plugin manager
        rm -rf bin
        mkdir bin
        ln -sfv ${cfg.package}/webapps/${cfg.package.name}.war bin/gerrit.war

        # copy the config, keep it mutable because Gerrit
        ln -sfv ${gerritConfig} etc/gerrit.config
        ln -sfv ${replicationConfig} etc/replication.config

        # install the plugins
        rm -rf plugins
        ln -sv ${gerrit-plugins} plugins
      ''
      ;

      serviceConfig = {
        CacheDirectory = "gerrit";
        DynamicUser = true;
        ExecStart = "${gerrit-cli}/bin/gerrit daemon --console-log";
        LimitNOFILE = 4096;
        StandardInput = "socket";
        StandardOutput = "journal";
        StateDirectory = "gerrit";
        WorkingDirectory = "%S/gerrit";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "noaccess";
        ProtectSystem = "full";
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 027;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ edef zimbatm ];
  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
