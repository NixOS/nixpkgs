{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.stump;

  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;

  secret = types.nullOr (
    types.str
    // {
      # We don't want users to be able to pass a path literal here but
      # it should look like a path.
      check = it: lib.isString it && lib.types.path.check it;
    }
  );
in
{
  options.services.stump = {
    enable = mkEnableOption "Stump";
    package = lib.mkPackageOption pkgs "stump" { };

    configLocation = mkOption {
      type = types.path;
      default = "/var/lib/stump";
      description = "Directory used to store the database and configuration files. If it is not the default, the directory has to be created manually such that the stump user is able to read and write to it.";
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        STUMP_VERBOSITY = "2";
      };
      description = ''
        Extra configuration environment variables. Refer to the [documentation](https://www.stumpapp.dev/docs/guides/configuration/server-config) for options.
      '';
    };

    environmentFile = mkOption {
      type = secret;
      example = "/run/secrets/stump";
      default = null;
      description = ''
        Path of a file with extra environment variables to be loaded from disk.
        This file is not added to the nix store, so it can be used to pass secrets to stump.
        Refer to the [documentation](https://www.stumpapp.dev/docs/guides/configuration/server-config) for options.
      '';
    };

    secretFiles = mkOption {
      type = types.attrsOf secret;
      example = {
        STUMP_OIDC_CLIENT_SECRET = "/run/secrets/stump_client_secret";
      };
      default = { };
      description = ''
        Attribute set containing paths to files to add to the environment of stump.
        The files are not added to the nix store, so they can be used to pass secrets to stump.
        Refer to the [documentation](https://www.stumpapp.dev/docs/guides/configuration/server-config) for options.
      '';
    };

    ip = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "The IP address that Stump will listen on.";
    };
    port = mkOption {
      type = types.port;
      default = 10001;
      description = "The port that Stump will listen on.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the Stump port in the firewall";
    };
    user = mkOption {
      type = types.str;
      default = "stump";
      description = "The user Stump should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "stump";
      description = "The group stump should run as.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    services.stump.environment = {
      STUMP_IP = cfg.ip;
      STUMP_PORT = toString cfg.port;
      STUMP_CONFIG_DIR = cfg.configLocation;
    };

    systemd.services.stump = {
      description = "Stump (A free and open source comics, manga and digital book server with OPDS support)";
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environment;
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;

        ExecStart =
          if cfg.secretFiles == { } then
            "${lib.getExe cfg.package}"
          else
            pkgs.writeShellScript "stump-env" ''
              ${lib.strings.concatStringsSep "\n" (
                lib.attrsets.mapAttrsToList (key: path: "export ${key}=$(< \"${path}\")") cfg.secretFiles
              )}
              ${lib.getExe cfg.package}
            '';
        EnvironmentFile = cfg.environmentFile;
        StateDirectory = "stump";
        User = cfg.user;
        Group = cfg.group;

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK" # is used to determine local ip
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    users.users = mkIf (cfg.user == "stump") {
      stump = {
        name = "stump";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "stump") { stump = { }; };

    meta.maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
