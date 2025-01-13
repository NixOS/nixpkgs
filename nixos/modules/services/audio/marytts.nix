{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.marytts;
  format = pkgs.formats.javaProperties { };
in
{
  options.services.marytts = {
    enable = lib.mkEnableOption "MaryTTS";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
      description = ''
        Settings for MaryTTS.

        See the [default settings](https://github.com/marytts/marytts/blob/master/marytts-runtime/conf/marybase.config)
        for a list of possible keys.
      '';
    };

    package = lib.mkPackageOption pkgs "marytts" { };

    basePath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/marytts";
      description = ''
        The base path in which MaryTTS runs.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 59125;
      description = ''
        Port to bind the MaryTTS server to.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to open the port in the firewall for MaryTTS.
      '';
    };

    voices = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression ''
        [
          (pkgs.fetchzip {
            url = "https://github.com/marytts/voice-bits1-hsmm/releases/download/v5.2/voice-bits1-hsmm-5.2.zip";
            hash = "sha256-1nK+qZxjumMev7z5lgKr660NCKH5FDwvZ9sw/YYYeaA=";
          })
        ]
      '';
      description = ''
        Paths to the JAR files that contain additional voices for MaryTTS.

        Voices are automatically detected by MaryTTS, so there is no need to alter
        your config to make use of new voices.
      '';
    };

    userDictionaries = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression ''
        [
          (pkgs.writeTextFile {
            name = "userdict-en_US";
            destination = "/userdict-en_US.txt";
            text = '''
              Nixpkgs | n I k s - ' p { - k @ - dZ @ s
            ''';
          })
        ]
      '';
      description = ''
        Paths to the user dictionary files for MaryTTS.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.marytts.settings = {
      "mary.base" = lib.mkDefault cfg.basePath;
      "socket.port" = lib.mkDefault cfg.port;
    };

    environment.systemPackages = [ cfg.package ];

    systemd.services.marytts = {
      description = "MaryTTS server instance";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # FIXME: MaryTTS's config loading mechanism appears to be horrendously broken
      # and it doesn't seem to actually read config files outside of precompiled JAR files.
      # Using system properties directly works for now, but this is really ugly.
      script = ''
        ${lib.getExe pkgs.marytts} -classpath "${cfg.basePath}/lib/*:${cfg.package}/lib/*" ${
          lib.concatStringsSep " " (lib.mapAttrsToList (n: v: ''-D${n}="${v}"'') cfg.settings)
        }
      '';

      restartTriggers = cfg.voices ++ cfg.userDictionaries;

      serviceConfig = {
        DynamicUser = true;
        User = "marytts";
        RuntimeDirectory = "marytts";
        StateDirectory = "marytts";
        Restart = "on-failure";
        RestartSec = 5;
        TimeoutSec = 20;

        # Hardening
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectHome = true;
        ProcSubset = "pid";

        PrivateTmp = true;
        PrivateNetwork = false;
        PrivateUsers = cfg.port >= 1024;
        PrivateDevices = true;

        RestrictRealtime = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];

        MemoryDenyWriteExecute = false; # Java does not like w^x :(
        LockPersonality = true;
        AmbientCapabilities = lib.optional (cfg.port < 1024) "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources"
          "~@privileged"
        ];
        UMask = "0027";
      };
    };

    systemd.tmpfiles.settings."10-marytts" = {
      "${cfg.basePath}/lib"."L+".argument = "${pkgs.symlinkJoin {
        name = "marytts-lib";

        # Put user paths before default ones so that user ones have priority
        paths = cfg.voices ++ [ "${cfg.package}/lib" ];
      }}";

      "${cfg.basePath}/user-dictionaries"."L+".argument = "${pkgs.symlinkJoin {
        name = "marytts-user-dictionaries";

        # Put user paths before default ones so that user ones have priority
        paths = cfg.userDictionaries ++ [ "${cfg.package}/user-dictionaries" ];
      }}";
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
