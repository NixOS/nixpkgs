{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkRemovedOptionModule
    types
    ;

  cfg = config.services.esphome;

  stateDir = "/var/lib/esphome";

  esphomeHttpParams =
    if cfg.enableUnixSocket then
      [ "--socket=/run/esphome/esphome.sock" ]
    else
      [
        "--host=${cfg.address}"
        "--port=${toString cfg.port}"
      ];

  esphomeParams =
    esphomeHttpParams
    ++ [
      "--log-level=${cfg.logLevel}"
      "--remote-build-host=${cfg.remoteBuildAddress}"
      "--remote-build-port=${toString cfg.remoteBuildPort}"
    ]
    ++ lib.optional cfg.remoteBuildOnly "--remote-build-only"
    ++ lib.optional (
      cfg.trustedDomains != [ ]
    ) "--trusted-domains=${lib.concatStringsSep "," cfg.trustedDomains}"
    ++ cfg.extraArgs;

  inherit (pkgs.stdenv.cc.bintools) dynamicLinker;
  loaderDir = "/${pkgs.stdenv.hostPlatform.libDir}";

  nixLdLibraries = pkgs.buildEnv {
    name = "esphome-nix-ld-libraries";
    paths = map lib.getLib cfg.nix-ld.libraries;
    pathsToLink = [ "/lib" ];
    ignoreCollisions = true;
  };
in
{
  meta.maintainers = with maintainers; [
    oddlama
    tmarkus
  ];

  options.services.esphome = {
    enable = mkEnableOption "ESPHome Device Builder, for making custom firmwares for ESP32/ESP8266";

    package = lib.mkPackageOption pkgs "esphome-device-builder" { };

    enableUnixSocket = mkOption {
      type = types.bool;
      default = false;
      description = "Listen on a unix socket `/run/esphome/esphome.sock` instead of the TCP port.";
    };

    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "ESPHome Device Builder HTTP address";
    };

    port = mkOption {
      type = types.port;
      default = 6052;
      description = "ESPHome Device Builder HTTP port";
    };

    remoteBuildOnly = mkOption {
      type = types.bool;
      default = false;
      description = "Only run a headless remote build server and disable the local web dashboard";
    };

    remoteBuildAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Address of the remote build server";
    };

    remoteBuildPort = mkOption {
      type = types.port;
      default = 6055;
      description = "Port of the remote build server";
    };

    logLevel = mkOption {
      type = types.enum [
        "debug"
        "info"
        "warning"
        "error"
      ];
      default = "info";
      description = "Log level of the ESPHome Device Builder";
    };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified port.";
    };

    trustedDomains = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Hostnames the WebSocket handshake trusts (case-insensitive, port-tolerant)";
    };

    allowedDevices = mkOption {
      default = [
        "char-ttyS"
        "char-ttyUSB"
      ];
      example = [
        "/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_0001-if00-port0"
      ];
      description = ''
        A list of device nodes to which {command}`esphome-device-builder` has access to.
        Refer to DeviceAllow in {manpage}`systemd.resource-control(5)` for more information.
        Beware that if a device is referred to by an absolute path instead of a device category,
        it will only allow devices that already are plugged in when the service is started.
      '';
      type = types.listOf types.str;
    };

    environment = mkOption {
      default = { };
      type = types.attrsOf types.str;
      description = ''
        Extra environment variables to pass to ESPHome. Secrets should be passed
        using the {option}`services.esphome.environmentFile` option.
      '';
      example = {
        ESPHOME_TRUSTED_DOMAINS = "dashboard.example.com";
      };
    };

    environmentFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        Path to an environment file.
        Use this option for setting the dashboard password.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra command line arguments for the ESPHome Device Builder.
      '';
    };

    nix-ld = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Whether to run the downloaded toolchains through [nix-ld](https://github.com/nix-community/nix-ld), inside the ESPHome unit only.
          Without it, the Device Builder cannot compile firmware with ESPHome's default toolchains.
          Set it to `false` to leave the unit's loader path and environment unchanged.

          ESPHome builds ESP32 firmware with ESP-IDF and ESP8266 firmware with its own Arduino toolchain by default, rather than through PlatformIO.
          Both toolchains download compilers and build tools built for generic Linux into the state directory.
          NixOS cannot run these binaries as they are, so compiling fails with `Could not start dynamically linked executable`.

          This option mounts nix-ld at the system's dynamic loader path in the unit's mount namespace.
          It points nix-ld at glibc and {option}`services.esphome.nix-ld.libraries`.
          Other programs keep the stub loader from {option}`environment.stub-ld.enable`.
          {option}`programs.nix-ld.enable` instead applies nix-ld to every program.
        '';
      };

      package = lib.mkPackageOption pkgs "nix-ld" { };

      libraries = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [
          stdenv.cc.cc
          zlib
          zstd
        ];
        defaultText = lib.literalExpression ''
          with pkgs; [
            stdenv.cc.cc
            zlib
            zstd
          ]
        '';
        example = lib.literalExpression ''
          with pkgs; [
            stdenv.cc.cc
            zlib
            zstd
            openssl
          ]
        '';
        description = ''
          Libraries the downloaded toolchains can load through nix-ld, besides glibc.
          The default covers the ESP-IDF and ESP8266 toolchains.
        '';
      };
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "esphome" "usePing" ] ''
      This option is no longer used by the ESPHome Device Builder which replaced the legacy ESPHome dashboard.
    '')
  ];

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall (
      [ cfg.remoteBuildPort ]
      ++ lib.optionals (!cfg.enableUnixSocket) [
        cfg.port
      ]
    );

    # Use a static system user instead of DynamicUser.
    # DynamicUser creates a /var/lib/esphome -> /var/lib/private/esphome symlink
    # which breaks PlatformIO's path resolution during firmware compilation.
    # See: https://github.com/NixOS/nixpkgs/issues/339557
    users.users.esphome = {
      isSystemUser = true;
      home = stateDir;
      group = "esphome";
    };

    users.groups.esphome = { };

    systemd.services.esphome = {
      description = "ESPHome Device Builder";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        cfg.package
        # ESP-IDF builds run ninja, which in nixpkgs spawns `sh` from PATH.
        pkgs.bashNonInteractive
      ];

      environment = {
        # Set PLATFORMIO_CORE_DIR to a real path (not a symlink) so PlatformIO
        # and its downloaded toolchains can resolve paths correctly.
        PLATFORMIO_CORE_DIR = "${stateDir}/.platformio";
        # platformio needs a writable HOME for its configuration
        HOME = stateDir;
      }
      // lib.optionalAttrs cfg.nix-ld.enable {
        NIX_LD = dynamicLinker;
        NIX_LD_LIBRARY_PATH = "${nixLdLibraries}/lib";
      }
      // cfg.environment;

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [ (lib.getExe cfg.package) ] ++ esphomeParams ++ [ stateDir ]
        );
        User = "esphome";
        Group = "esphome";
        WorkingDirectory = stateDir;
        StateDirectory = "esphome";
        StateDirectoryMode = "0750";
        Restart = "on-failure";
        RuntimeDirectory = mkIf cfg.enableUnixSocket "esphome";
        RuntimeDirectoryMode = "0750";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ReadWritePaths = [ stateDir ];
        ExecPaths = [ stateDir ];
        # The loader path is a symlink to stub-ld, which systemd would follow
        # and mount nix-ld over stub-ld's store path; mount on a tmpfs instead.
        TemporaryFileSystem = mkIf cfg.nix-ld.enable [ "${loaderDir}:ro" ];
        BindReadOnlyPaths = mkIf cfg.nix-ld.enable [
          "${cfg.nix-ld.package}/libexec/nix-ld:${loaderDir}/${baseNameOf dynamicLinker}"
        ];

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        DevicePolicy = "closed";
        DeviceAllow = map (d: "${d} rw") cfg.allowedDevices;
        SupplementaryGroups = [ "dialout" ];
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = false; # breaks bwrap
        ProtectKernelLogs = false; # breaks bwrap
        ProtectKernelModules = true;
        ProtectKernelTunables = false; # breaks bwrap
        ProtectProc = "invisible";
        ProcSubset = "all"; # Using "pid" breaks bwrap
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = false; # Required by platformio for chroot
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@mount" # Required by platformio for chroot
        ];
        UMask = "0077";
      };
    };
  };
}
