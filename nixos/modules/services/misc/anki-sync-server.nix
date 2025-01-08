{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.anki-sync-server;
  name = "anki-sync-server";
  specEscape = lib.replaceStrings ["%"] ["%%"];
  usersWithIndexes =
    lib.lists.imap1 (i: user: {
      i = i;
      user = user;
    })
    cfg.users;
  usersWithIndexesFile = lib.filter (x: x.user.passwordFile != null) usersWithIndexes;
  usersWithIndexesNoFile = lib.filter (x: x.user.passwordFile == null && x.user.password != null) usersWithIndexes;
  anki-sync-server-run = pkgs.writeShellScript "anki-sync-server-run" ''
    # When services.anki-sync-server.users.passwordFile is set,
    # each password file is passed as a systemd credential, which is mounted in
    # a file system exposed to the service. Here we read the passwords from
    # the credential files to pass them as environment variables to the Anki
    # sync server.
    ${
      lib.concatMapStringsSep
      "\n"
      (x: ''
        read -r pass < "''${CREDENTIALS_DIRECTORY}/"${lib.escapeShellArg x.user.username}
        export SYNC_USER${toString x.i}=${lib.escapeShellArg x.user.username}:"$pass"
      '')
      usersWithIndexesFile
    }
    # For users where services.anki-sync-server.users.password isn't set,
    # export passwords in environment variables in plaintext.
    ${
      lib.concatMapStringsSep
      "\n"
      (x: ''export SYNC_USER${toString x.i}=${lib.escapeShellArg x.user.username}:${lib.escapeShellArg x.user.password}'')
      usersWithIndexesNoFile
    }
    exec ${lib.getExe cfg.package}
  '';
in {
  options.services.anki-sync-server = {
    enable = lib.mkEnableOption "anki-sync-server";

    package = lib.mkPackageOption pkgs "anki-sync-server" { };

    address = lib.mkOption {
      type = lib.types.str;
      default = "::1";
      description = ''
        IP address anki-sync-server listens to.
        Note host names are not resolved.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 27701;
      description = "Port number anki-sync-server listens to.";
    };

    baseDirectory = lib.mkOption {
      type = lib.types.str;
      default = "%S/%N";
      description = "Base directory where user(s) synchronized data will be stored.";
    };


    openFirewall = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to open the firewall for the specified port.";
    };

    users = lib.mkOption {
      type = with lib.types;
        listOf (submodule {
          options = {
            username = lib.mkOption {
              type = str;
              description = "User name accepted by anki-sync-server.";
            };
            password = lib.mkOption {
              type = nullOr str;
              default = null;
              description = ''
                Password accepted by anki-sync-server for the associated username.
                **WARNING**: This option is **not secure**. This password will
                be stored in *plaintext* and will be visible to *all users*.
                See {option}`services.anki-sync-server.users.passwordFile` for
                a more secure option.
              '';
            };
            passwordFile = lib.mkOption {
              type = nullOr path;
              default = null;
              description = ''
                File containing the password accepted by anki-sync-server for
                the associated username.  Make sure to make readable only by
                root.
              '';
            };
          };
        });
      description = "List of user-password pairs to provide to the sync server.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (builtins.length usersWithIndexesFile) + (builtins.length usersWithIndexesNoFile) > 0;
        message = "At least one username-password pair must be set.";
      }
    ];
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];

    systemd.services.anki-sync-server = {
      description = "anki-sync-server: Anki sync server built into Anki";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      path = [cfg.package];
      environment = {
        SYNC_BASE = cfg.baseDirectory;
        SYNC_HOST = specEscape cfg.address;
        SYNC_PORT = toString cfg.port;
      };

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = name;
        ExecStart = anki-sync-server-run;
        Restart = "always";
        LoadCredential =
          map
          (x: "${specEscape x.user.username}:${specEscape (toString x.user.passwordFile)}")
          usersWithIndexesFile;
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [telotortium];
    doc = ./anki-sync-server.md;
  };
}
