{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nix-post-build-hook-queue;
in
{
  options.services.nix-post-build-hook-queue = with lib; {
    enable = lib.mkEnableOption "nix-post-build-hook-queue";

    signingPrivateKeyPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/nix-store-signing-priv-key";
      description = ''
        Path to the PEM encoded private key to sign store paths.

        Paths will not be signed if null.
      '';
    };

    uploadTo = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "ssh://nix-ssh@nix-cache.example.com";
      description = ''
        Binary cache to upload store paths to after building.

        Paths will not be uploaded if null.
      '';
    };

    sshPrivateKeyPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/ssh-priv-key";
      description = ''
        Path to a private SSH key file.

        This is only relevant if `services.nix-post-build-hook-queue.uploadTo`
        is set to an SSH URL.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !lib.isStorePath cfg.signingPrivateKeyPath;
        message = ''
          services.nix-post-build-hook-queue.signingPrivateKeyPath
          points to a file in the Nix store.
          You should use a quoted absolute path to prevent this.
        '';
      }
      {
        assertion = !lib.isStorePath cfg.sshPrivateKeyPath;
        message = ''
          services.nix-post-build-hook-queue.sshPrivateKeyPath
          points to a file in the Nix store.
          You should use a quoted absolute path to prevent this.
        '';
      }
    ];

    systemd.sockets.nix-post-build-hook-queue = {
      listenDatagrams = [ "/run/nix-post-build-hook-queue.sock" ];
      wantedBy = [ "sockets.target" ];
      partOf = [ "nix-post-build-hook-queue.service" ];
      socketConfig = {
        SocketMode = "0600";
        # start the service on incoming traffic
        Service = "nix-post-build-hook-queue.service";
      };
    };

    nix.settings.post-build-hook = lib.getExe' pkgs.nix-post-build-hook-queue "post-build-hook";

    systemd.services.nix-post-build-hook-queue = {
      after = lib.optionals (cfg.uploadTo != null) [ "network.target" ];
      description = "nix-post-build-hook-queue";
      path = [ config.nix.package ] ++ lib.optionals (cfg.uploadTo != null) [ pkgs.openssh ];
      environment = {
        NIX_SSHOPTS =
          "-o IPQoS=throughput"
          + lib.optionalString (cfg.sshPrivateKeyPath != null) " -i %d/sshPrivateKeyPath";
      }
      // lib.optionalAttrs (cfg.signingPrivateKeyPath != null) {
        NPBHQ_SIGNING_PRIVATE_KEY_PATH = "%d/signingPrivateKeyPath";
      }
      // lib.optionalAttrs (cfg.uploadTo != null) {
        NPBHQ_UPLOAD_TO = cfg.uploadTo;
      };

      serviceConfig = {
        Type = "idle";
        KillSignal = "SIGINT";
        ExecStart = lib.getExe' pkgs.nix-post-build-hook-queue "post-build-hook-queue";
        StandardInput = "socket";
        RuntimeDirectory = "nix-post-build-hook-queue";
        LoadCredential =
          [ ]
          ++ lib.optionals (cfg.signingPrivateKeyPath != null) [
            "signingPrivateKeyPath:${cfg.signingPrivateKeyPath}"
          ]
          ++ lib.optionals (cfg.sshPrivateKeyPath != null) [
            "sshPrivateKeyPath:${cfg.sshPrivateKeyPath}"
          ];

        # disable rate limiting
        StartLimitBurst = 0;

        # hardening
        DynamicUser = true;
        DevicePolicy = "closed";
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_UNIX"
        ]
        ++ lib.optionals (cfg.uploadTo != null) [
          "AF_INET"
          "AF_INET6"
        ];
        DeviceAllow = [ ];
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        BindPaths = [ ];
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        ProtectProc = "invisible";
        ProtectHostname = true;
        UMask = "0077";

        # permissive to prevent GC warnings
        # "GC Warning: Couldn't read /proc/stat"
        ProcSubset = "all";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ newam ];
}
