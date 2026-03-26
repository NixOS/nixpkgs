{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    literalExpression
    makeLibraryPath
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    optional
    types
    ;

  cfg = config.services.aesmd;
  sgx-psw = cfg.package;

  # See `psw/ae/aesm_service/source/utils/aesm_config.cpp` for available options
  configFile =
    let
      c = cfg.settings;
      lines =
        optional (c.defaultQuotingType != null) "default quoting type = ${c.defaultQuotingType}"
        ++ optional (c.qplLogLevel != null) "qpl log level = ${c.qplLogLevel}"
        ++ optional (c.proxy != null) "aesm proxy = ${c.proxy}"
        ++ optional (c.proxyType != null) "proxy type = ${c.proxyType}"
        ++
          # Newline at end of file
          [ "" ];
    in
    pkgs.writeText "aesmd.conf" (concatStringsSep "\n" lines);
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "aesmd" "debug" ] ''
      Enable debug mode by overriding the aesmd package directly:

          services.aesmd.package = pkgs.sgx-psw.override { debug = true; };
    '')
    (mkRemovedOptionModule [
      "services"
      "aesmd"
      "settings"
      "whitelistUrl"
    ] "sgx-psw-v2.28 no longer supports Intel enclave signer cert whitelist management.")
  ];

  options.services.aesmd = {
    enable = mkEnableOption "Intel's Architectural Enclave Service Manager (AESM) for Intel SGX";
    package = mkPackageOption pkgs "sgx-psw" { };
    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Additional environment variables to pass to the AESM service.";
      # Example environment variable for `sgx-azure-dcap-client` provider library
      example = {
        AZDCAP_COLLATERAL_VERSION = "v2";
        AZDCAP_DEBUG_LOG_LEVEL = "INFO";
      };
    };
    quoteProviderLibrary = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = literalExpression "pkgs.sgx-azure-dcap-client";
      description = "Custom quote provider library to use.";
    };
    settings = {
      proxy = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "http://proxy_url:1234";
        description = "HTTP network proxy.";
      };
      proxyType = mkOption {
        type = types.nullOr (
          types.enum [
            "default"
            "direct"
            "manual"
          ]
        );
        default = if (cfg.settings.proxy != null) then "manual" else null;
        defaultText = literalExpression ''
          if (cfg.settings.proxy != null) then "manual" else null
        '';
        example = "default";
        description = ''
          Type of proxy to use. The `default` uses the system's default proxy.
          If `direct` is given, uses no proxy.
          A value of `manual` uses the proxy from
          {option}`services.aesmd.settings.proxy`.
        '';
      };
      defaultQuotingType = mkOption {
        # As of sgx-psw-v2.28 EPID attestation is no longer supported.
        type = types.nullOr (types.enum [ "ecdsa_256" ]);
        default = null;
        example = "ecdsa_256";
        description = "Attestation quote type.";
      };
      qplLogLevel = mkOption {
        type = types.nullOr (
          types.enum [
            "info"
            "error"
          ]
        );
        default = null;
        example = "error";
        description = "Set the log level for the default quote provider library";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(config.boot.specialFileSystems."/dev".options ? "noexec");
        message = "SGX requires exec permission for /dev";
      }
    ];

    hardware.cpu.intel.sgx.provision.enable = true;

    systemd.services.aesmd =
      let
        storeAesmFolder = "${sgx-psw}/aesm";
      in
      {
        description = "Intel Architectural Enclave Service Manager";
        wantedBy = [ "multi-user.target" ];

        after = [
          "auditd.service"
          "network.target"
        ];

        environment = {
          NAME = "aesm_service";
          AESM_PATH = storeAesmFolder;
          LD_LIBRARY_PATH = makeLibraryPath [ cfg.quoteProviderLibrary ];
        }
        // cfg.environment;

        # Ensure the SGX application enclave device is available
        unitConfig.AssertPathExists = [ "/dev/sgx_enclave" ];

        serviceConfig = {
          # Run with elevated privileges to create /var/opt/aesmd/... before
          # dropping to DynamicUser. This is a hardcoded path `AESM_DATA_FOLDER`
          # in `psw/ae/aesm_service/source/oal/linux/aesm_util.cpp`.
          ExecStartPre = "+${lib.getExe' pkgs.coreutils "mkdir"} -p -m 755 /var/opt/aesmd/data";
          ExecStart = "${sgx-psw}/bin/aesm_service --no-daemon";
          ExecReload = ''${pkgs.coreutils}/bin/kill -SIGHUP "$MAINPID"'';

          Restart = "on-failure";
          RestartSec = "15s";

          DynamicUser = true;
          Group = "sgx";
          SupplementaryGroups = [
            config.hardware.cpu.intel.sgx.provision.group
          ];

          Type = "simple";

          WorkingDirectory = storeAesmFolder;
          StateDirectory = "aesmd";
          StateDirectoryMode = "0700";
          RuntimeDirectory = "aesmd";
          RuntimeDirectoryMode = "0750";

          # --- Hardening ---

          RootDirectory = "%t/aesmd";
          BindReadOnlyPaths = [
            builtins.storeDir
            # Hardcoded path AESM_CONFIG_FILE in psw/ae/aesm_service/source/utils/aesm_config.cpp
            "${configFile}:/etc/aesmd.conf"
          ];
          BindPaths = [
            # Hardcoded path CONFIG_SOCKET_PATH in psw/ae/aesm_service/source/core/ipc/SocketConfig.h
            "%t/aesmd:/var/run/aesmd"
            "%S/aesmd:/var/opt/aesmd"
          ];

          # PrivateDevices=true will mount /dev noexec which breaks AESM
          PrivateDevices = false;
          DevicePolicy = "closed";
          DeviceAllow = [
            # in-tree driver
            "/dev/sgx_enclave rw"
            "/dev/sgx_provision rw"
          ];

          # Requires Internet access for attestation
          PrivateNetwork = false;

          RestrictAddressFamilies = [
            # Allocates the socket /var/run/aesmd/aesm.socket
            "AF_UNIX"
            # Makes HTTPS requests to the Intel PCCS service (or a cache).
            "AF_INET"
            "AF_INET6"
          ];

          # True breaks stuff
          MemoryDenyWriteExecute = false;

          # needs the ipc syscall in order to run
          SystemCallFilter = [
            "@system-service"
            "~@aio"
            "~@chown"
            "~@clock"
            "~@cpu-emulation"
            "~@debug"
            "~@keyring"
            "~@memlock"
            "~@module"
            "~@mount"
            "~@privileged"
            "~@raw-io"
            "~@reboot"
            "~@resources"
            "~@setuid"
            "~@swap"
            "~@sync"
            "~@timer"
          ];
          SystemCallArchitectures = "native";
          SystemCallErrorNumber = "EPERM";

          CapabilityBoundingSet = "";
          KeyringMode = "private";
          LockPersonality = true;
          NoNewPrivileges = true;
          NotifyAccess = "none";
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          UMask = "0066";
        };
      };
  };

  meta = {
    maintainers = with lib.maintainers; [
      phlip9
    ];
  };
}
