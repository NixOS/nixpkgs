{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.openbao;

  settingsFormat = pkgs.formats.json { };
in
{
  options = {
    services.openbao = {
      enable = lib.mkEnableOption "OpenBao daemon";

      package = lib.mkPackageOption pkgs "openbao" { };

      settings = lib.mkOption {
        description = ''
          Settings of OpenBao.

          See [documentation](https://openbao.org/docs/configuration) for more details.
        '';
        example = lib.literalExpression ''
          {
            listener.tcp = {
              tls_acme_email = config.security.acme.defaults.email;
              tls_acme_domains = [ "example.com" ];
              tls_acme_disable_http_challenge = true;
            };

            cluster_addr = "http://127.0.0.1:8201";
            api_addr = "https://example.com";

            storage.raft = {
              path = "/var/lib/openbao";
              node_id = config.networking.hostName;
            };
          }
        '';
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            listener.tcp = {
              address = lib.mkOption {
                type = lib.types.str;
                default = "127.0.0.1:8200";
                description = ''
                  Specifies the address to bind to for listening.
                '';
              };

              cluster_address = lib.mkOption {
                type = lib.types.str;
                default = "127.0.0.1:8201";
                description = ''
                  The address the OpenBao daemon will listen to for cluster server-to-server requests.
                  Specifies the address to bind to for cluster server-to-server requests.
                '';
              };
            };
          };
        };
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Additional arguments given to OpenBao.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.openbao = {
      description = "OpenBao - A tool for managing secrets";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      restartIfChanged = false; # do not restart on "nixos-rebuild switch". It would seal the storage and disrupt the clients.

      serviceConfig = {
        Type = "notify";

        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "server"
            "-config"
            (settingsFormat.generate "openbao.hcl.json" cfg.settings)
          ]
          ++ cfg.extraArgs
        );
        ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -SIGHUP $MAINPID";

        StateDirectory = "openbao";
        StateDirectoryMode = "0700";

        CapabilityBoundingSet = [ "" ];
        DeviceAllow = "";
        DynamicUser = true;
        LimitCORE = 0;
        LockPersonality = true;
        MemorySwapMax = 0;
        MemoryZSwapMax = 0;
        PrivateDevices = true;
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
        Restart = "on-failure";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}
