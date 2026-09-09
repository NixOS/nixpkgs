{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib) types;
  cfg = config.services.kiwix-serve;
  # Create a directory containing symlinks to ZIM files
  mkLibrary =
    library:
    let
      libraryEntries = lib.mapAttrsToList (name: path: {
        name = "${name}.zim";
        inherit path;
      }) library;

      zimsDrv = pkgs.linkFarm "zims" libraryEntries;

      files = map (entry: "${zimsDrv}/${entry.name}") libraryEntries;
    in
    {
      derivation = zimsDrv;
      inherit files;
    };
in
{
  options = {
    services.kiwix-serve = {
      enable = lib.mkEnableOption "the kiwix-serve server";

      package = lib.mkPackageOption pkgs "kiwix-tools" { };

      address = lib.mkOption {
        type = types.str;
        default = "all";
        example = "ipv4";
        description = ''
          Listen only on the specified IP address.
          Specify "ipv4", "ipv6" or "all" to listen on all IPv4, IPv6, or both types of addresses, respectively.
        '';
      };

      port = lib.mkOption {
        type = types.port;
        default = 8080;
        description = "The port on which to run kiwix-serve.";
      };

      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open the firewall for the configured port.";
      };

      library = lib.mkOption {
        type = types.attrsOf types.path;
        default = { };
        example = lib.literalExpression (
          lib.removeSuffix "\n" ''
            {
              wikipedia = "/data/wikipedia_en_all_maxi_2026-02.zim";
              nix = pkgs.fetchurl {
                url = "https://download.kiwix.org/zim/devdocs/devdocs_en_nix_2026-01.zim";
                hash = "sha256-QxB9qDKSzzEU8t4droI08BXdYn+HMVkgiJMO3SoGTqM=";
              };
            }
          ''
        );
        description = ''
          A set of ZIM files to serve. The key is used as the name for the ZIM files
          (e.g. in the example, the files will be served as `wikipedia.zim` and `nix.zim`).

          Exclusive with [services.kiwix-serve.libraryPath](#opt-services.kiwix-serve.libraryPath).
        '';
      };

      libraryPath = lib.mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/data/library.xml";
        description = ''
          An XML library file listing ZIM files to serve.
          For more information, see <https://wiki.kiwix.org/wiki/Kiwix-manage>.

          Exclusive with [services.kiwix-serve.library](#opt-services.kiwix-serve.library).
        '';
      };

      extraArgs = lib.mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [
          "--verbose"
          "--skipInvalid"
        ];
        description = "Extra arguments to pass to kiwix-serve.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.library == { }) != (cfg.libraryPath == null);
        message = "Exactly one of services.kiwix-serve.library or services.kiwix-serve.libraryPath must be provided.";
      }
    ];

    systemd.services.kiwix-serve =
      let
        library = mkLibrary cfg.library;
      in
      {
        description = "ZIM file HTTP server";
        documentation = [ "https://kiwix-tools.readthedocs.io/en/latest/kiwix-serve.html" ];
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "exec";
          DynamicUser = true;
          Restart = "on-failure";
          ExecStart = utils.escapeSystemdExecArgs (
            [
              (lib.getExe' cfg.package "kiwix-serve")
              "--address"
              cfg.address
              "--port"
              cfg.port
            ]
            ++ lib.optionals (cfg.libraryPath != null) [
              "--library"
              cfg.libraryPath
            ]
            ++ lib.optionals (cfg.library != { }) library.files
            ++ cfg.extraArgs
          );

          CapabilityBoundingSet = "";
          DeviceAllow = "";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateUsers = true;
          PrivateTmp = true;
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
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          UMask = "0077";
        };
      };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
  };
}
