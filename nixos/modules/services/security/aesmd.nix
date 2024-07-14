{ config, options, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.aesmd;
  opt = options.services.aesmd;

  sgx-psw = pkgs.sgx-psw.override { inherit (cfg) debug; };

  configFile = with cfg.settings; pkgs.writeText "aesmd.conf" (
    concatStringsSep "\n" (
      optional (whitelistUrl != null) "whitelist url = ${whitelistUrl}" ++
      optional (proxy != null) "aesm proxy = ${proxy}" ++
      optional (proxyType != null) "proxy type = ${proxyType}" ++
      optional (defaultQuotingType != null) "default quoting type = ${defaultQuotingType}" ++
      # Newline at end of file
      [ "" ]
    )
  );
in
{
  options.services.aesmd = {
    enable = mkEnableOption "Intel's Architectural Enclave Service Manager (AESM) for Intel SGX";
    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to build the PSW package in debug mode.";
    };
    environment = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "Additional environment variables to pass to the AESM service.";
      # Example environment variable for `sgx-azure-dcap-client` provider library
      example = {
        AZDCAP_COLLATERAL_VERSION = "v2";
        AZDCAP_DEBUG_LOG_LEVEL = "INFO";
      };
    };
    quoteProviderLibrary = mkOption {
      type = with types; nullOr path;
      default = null;
      example = literalExpression "pkgs.sgx-azure-dcap-client";
      description = "Custom quote provider library to use.";
    };
    settings = mkOption {
      description = "AESM configuration";
      default = { };
      type = types.submodule {
        options.whitelistUrl = mkOption {
          type = with types; nullOr str;
          default = null;
          example = "http://whitelist.trustedservices.intel.com/SGX/LCWL/Linux/sgx_white_list_cert.bin";
          description = "URL to retrieve authorized Intel SGX enclave signers.";
        };
        options.proxy = mkOption {
          type = with types; nullOr str;
          default = null;
          example = "http://proxy_url:1234";
          description = "HTTP network proxy.";
        };
        options.proxyType = mkOption {
          type = with types; nullOr (enum [ "default" "direct" "manual" ]);
          default = if (cfg.settings.proxy != null) then "manual" else null;
          defaultText = literalExpression ''
            if (config.${opt.settings}.proxy != null) then "manual" else null
          '';
          example = "default";
          description = ''
            Type of proxy to use. The `default` uses the system's default proxy.
            If `direct` is given, uses no proxy.
            A value of `manual` uses the proxy from
            {option}`services.aesmd.settings.proxy`.
          '';
        };
        options.defaultQuotingType = mkOption {
          type = with types; nullOr (enum [ "ecdsa_256" "epid_linkable" "epid_unlinkable" ]);
          default = null;
          example = "ecdsa_256";
          description = "Attestation quote type.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = !(config.boot.specialFileSystems."/dev".options ? "noexec");
      message = "SGX requires exec permission for /dev";
    }];

    hardware.cpu.intel.sgx.provision.enable = true;

    # Make sure the AESM service can find the SGX devices until
    # https://github.com/intel/linux-sgx/issues/772 is resolved
    # and updated in nixpkgs.
    hardware.cpu.intel.sgx.enableDcapCompat = mkForce true;

    systemd.services.aesmd =
      let
        storeAesmFolder = "${sgx-psw}/aesm";
        # Hardcoded path AESM_DATA_FOLDER in psw/ae/aesm_service/source/oal/linux/aesm_util.cpp
        aesmDataFolder = "/var/opt/aesmd/data";
      in
      {
        description = "Intel Architectural Enclave Service Manager";
        wantedBy = [ "multi-user.target" ];

        after = [
          "auditd.service"
          "network.target"
          "syslog.target"
        ];

        environment = {
          NAME = "aesm_service";
          AESM_PATH = storeAesmFolder;
          LD_LIBRARY_PATH = makeLibraryPath [ cfg.quoteProviderLibrary ];
        } // cfg.environment;

        # Make sure any of the SGX application enclave devices is available
        unitConfig.AssertPathExists = [
          # legacy out-of-tree driver
          "|/dev/isgx"
          # DCAP driver
          "|/dev/sgx/enclave"
          # in-tree driver
          "|/dev/sgx_enclave"
        ];

        serviceConfig = rec {
          ExecStartPre = pkgs.writeShellScript "copy-aesmd-data-files.sh" ''
            set -euo pipefail
            whiteListFile="${aesmDataFolder}/white_list_cert_to_be_verify.bin"
            if [[ ! -f "$whiteListFile" ]]; then
              ${pkgs.coreutils}/bin/install -m 644 -D \
                "${storeAesmFolder}/data/white_list_cert_to_be_verify.bin" \
                "$whiteListFile"
            fi
          '';
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

          # Hardening

          # chroot into the runtime directory
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
            # legacy out-of-tree driver
            "/dev/isgx rw"
            # DCAP driver
            "/dev/sgx rw"
            # in-tree driver
            "/dev/sgx_enclave rw"
            "/dev/sgx_provision rw"
          ];

          # Requires Internet access for attestation
          PrivateNetwork = false;

          RestrictAddressFamilies = [
            # Allocates the socket /var/run/aesmd/aesm.socket
            "AF_UNIX"
            # Uses the HTTP protocol to initialize some services
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
}
