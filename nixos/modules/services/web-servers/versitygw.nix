{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.versitygw;
  stateDirectory = "/var/lib/versitygw";
  iamDirectory = "${stateDirectory}/iam";
  seedUsers = pkgs.writeShellScript "versitygw-seed-users" ''
    set -eu
    ${pkgs.coreutils}/bin/install -d -m 0700 ${lib.escapeShellArg iamDirectory}
    ${lib.optionalString (cfg.usersFile != null) ''
      ${pkgs.coreutils}/bin/install -m 0600 \
        "$CREDENTIALS_DIRECTORY/users.json" ${lib.escapeShellArg "${iamDirectory}/users.json"}
    ''}
  '';
in
{
  meta = {
    doc = ./versitygw.md;
    maintainers = [ lib.maintainers.rrittste ];
  };

  options.services.versitygw = {
    enable = lib.mkEnableOption "the Versity S3 Gateway";
    package = lib.mkPackageOption pkgs "versitygw" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "versitygw";
      example = "s3-gateway";
      description = "User account under which the gateway runs. A non-default account must already exist.";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "versitygw";
      example = "s3-gateway";
      description = "Group under which the gateway runs. A non-default group must already exist.";
    };
    backend = lib.mkOption {
      type = lib.types.enum [
        "posix"
        "scoutfs"
      ];
      default = "posix";
      example = "scoutfs";
      description = "Filesystem backend. The filesystem must support extended attributes.";
    };
    rootDirectory = lib.mkOption {
      type = lib.types.path;
      example = "/srv/versitygw";
      description = ''
        Directory served by the gateway. Each subdirectory is a bucket and
        objects are stored as files. The directory is created if missing and
        its ownership is set to the service user and group.
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.path;
      example = "/run/secrets/versitygw.env";
      description = ''
        Runtime environment file containing ROOT_ACCESS_KEY and ROOT_SECRET_KEY.
        Use an absolute path as a string, not a Nix path literal, to keep the
        credentials out of the Nix store. Values override those in settings.
      '';
    };
    usersFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/versitygw-users.json";
      description = ''
        Runtime JSON IAM account store, copied to /var/lib/versitygw/iam/users.json
        with mode 0600 before every start. The source may be owned by root.
        It is loaded as a systemd credential, subject to systemd's total
        credential size limit (currently 1 MB per service).
        Use an absolute path as a string to keep account secrets out of the
        Nix store. When set, accounts created through the admin API are
        discarded on restart; otherwise the gateway manages its own IAM store.
      '';
    };
    settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          nullOr (oneOf [
            str
            int
            bool
          ])
        );
      default = { };
      example = {
        VGW_PORT = "127.0.0.1:7070";
        VGW_ADMIN_PORT = "127.0.0.1:7080";
        VGW_REGION = "us-east-1";
      };
      description = ''
        Environment variables documented by versitygw --help. Booleans are
        rendered as true or false; null values are omitted. Never put secrets
        here: they become world-readable in the Nix store. Use environmentFile
        instead. VGW_IAM_DIR is managed by this module.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? VGW_IAM_DIR);
        message = "services.versitygw.settings must not set VGW_IAM_DIR; the module manages the IAM directory.";
      }
      {
        assertion =
          !lib.any (key: builtins.hasAttr key cfg.settings) [
            "ROOT_ACCESS_KEY"
            "ROOT_ACCESS_KEY_ID"
            "ROOT_SECRET_KEY"
            "ROOT_SECRET_ACCESS_KEY"
          ];
        message = "services.versitygw.settings must not contain root credentials; use environmentFile instead.";
      }
    ];

    users.users = lib.mkIf (cfg.user == "versitygw") {
      versitygw = {
        isSystemUser = true;
        inherit (cfg) group;
        home = stateDirectory;
      };
    };
    users.groups = lib.mkIf (cfg.group == "versitygw") { versitygw = { }; };

    systemd.tmpfiles.rules = [
      "d ${
        builtins.toJSON (lib.replaceStrings [ "%" ] [ "%%" ] cfg.rootDirectory)
      } 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.versitygw = {
      description = "Versity S3 Gateway";
      documentation = [ "https://github.com/versity/versitygw" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = lib.mapAttrs (
        _: value: if lib.isBool value then lib.boolToString value else toString value
      ) (lib.filterAttrs (_: value: value != null) cfg.settings);
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "versitygw";
        StateDirectoryMode = "0700";
        EnvironmentFile = cfg.environmentFile;
        LoadCredential = lib.optional (cfg.usersFile != null) "users.json:${toString cfg.usersFile}";
        ExecStartPre = seedUsers;
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "--iam-dir"
          iamDirectory
          cfg.backend
          cfg.rootDirectory
        ];
        Restart = "on-failure";
        RestartSec = 5;
        UMask = "0077";
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
        ReadWritePaths = [ (builtins.toJSON (lib.replaceStrings [ "%" ] [ "%%" ] cfg.rootDirectory)) ];
      };
    };
  };
}
