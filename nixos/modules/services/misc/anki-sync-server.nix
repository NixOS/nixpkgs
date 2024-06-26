{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.anki-sync-server;
  name = "anki-sync-server";
  specEscape = replaceStrings [ "%" ] [ "%%" ];
  usersWithIndexes = lists.imap1 (i: user: {
    i = i;
    user = user;
  }) cfg.users;
  usersWithIndexesFile = filter (x: x.user.passwordFile != null) usersWithIndexes;
  usersWithIndexesNoFile = filter (
    x: x.user.passwordFile == null && x.user.password != null
  ) usersWithIndexes;
  anki-sync-server-run = pkgs.writeShellScriptBin "anki-sync-server-run" ''
    # When services.anki-sync-server.users.passwordFile is set,
    # each password file is passed as a systemd credential, which is mounted in
    # a file system exposed to the service. Here we read the passwords from
    # the credential files to pass them as environment variables to the Anki
    # sync server.
    ${concatMapStringsSep "\n" (
      x:
      ''export SYNC_USER${toString x.i}=${escapeShellArg x.user.username}:"''$(cat "''${CREDENTIALS_DIRECTORY}/"${escapeShellArg x.user.username})"''
    ) usersWithIndexesFile}
    # For users where services.anki-sync-server.users.password isn't set,
    # export passwords in environment variables in plaintext.
    ${concatMapStringsSep "\n" (
      x:
      ''export SYNC_USER${toString x.i}=${escapeShellArg x.user.username}:${escapeShellArg x.user.password}''
    ) usersWithIndexesNoFile}
    exec ${cfg.package}/bin/anki-sync-server
  '';
in
{
  options.services.anki-sync-server = {
    enable = mkEnableOption "anki-sync-server";

    package = mkPackageOption pkgs "anki-sync-server" { };

    address = mkOption {
      type = types.str;
      default = "::1";
      description = ''
        IP address anki-sync-server listens to.
        Note host names are not resolved.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 27701;
      description = "Port number anki-sync-server listens to.";
    };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified port.";
    };

    users = mkOption {
      type =
        with types;
        listOf (submodule {
          options = {
            username = mkOption {
              type = str;
              description = "User name accepted by anki-sync-server.";
            };
            password = mkOption {
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
            passwordFile = mkOption {
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

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (builtins.length usersWithIndexesFile) + (builtins.length usersWithIndexesNoFile) > 0;
        message = "At least one username-password pair must be set.";
      }
    ];
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.anki-sync-server = {
      description = "anki-sync-server: Anki sync server built into Anki";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      environment = {
        SYNC_BASE = "%S/%N";
        SYNC_HOST = specEscape cfg.address;
        SYNC_PORT = toString cfg.port;
      };

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = name;
        ExecStart = "${anki-sync-server-run}/bin/anki-sync-server-run";
        Restart = "always";
        LoadCredential = map (
          x: "${specEscape x.user.username}:${specEscape (toString x.user.passwordFile)}"
        ) usersWithIndexesFile;
      };
    };
  };

  meta = {
    maintainers = with maintainers; [ telotortium ];
    doc = ./anki-sync-server.md;
  };
}
