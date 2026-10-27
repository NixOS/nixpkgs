{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.vscodium-server;
  defaultUser = "vscodium-server";
  defaultGroup = defaultUser;
in
{
  options =
    with lib;
    with types;
    {
      services.vscodium-server = {
        enable = mkEnableOption "vscodium-server";

        binary = mkOption {
          type = str;
          default = "${pkgs.vscodiumFromSource.web}/bin/codium-server";
          defaultText = "\${pkgs.vscodiumFromSource.web}/bin/codium-server";
          description = ''
            VSCodium Web binary
          '';
        };

        extraPackages = mkOption {
          default = [ ];
          description = ''
            Additional packages to add to the vscodium-server {env}`PATH`.
          '';
          example = literalExpression "[ pkgs.go ]";
          type = listOf package;
        };

        extraEnvironment = mkOption {
          type = attrsOf str;
          description = ''
            Additional environment variables to pass to vscodium-server.
          '';
          default = { };
          example = {
            PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
          };
        };

        extraArguments = mkOption {
          default = [ ];
          description = ''
            Additional arguments to pass to vscodium-server.
          '';
          example = literalExpression ''[ "--log=info" ]'';
          type = listOf str;
        };

        host = mkOption {
          default = "localhost";
          description = ''
            The host name or IP address the server should listen to.
          '';
          type = str;
        };

        port = mkOption {
          default = 3000;
          description = ''
            The port the server should listen to. If 0 is passed a random free port is picked. If a range in the format num-num is passed, a free port from the range (end inclusive) is selected.
          '';
          type = port;
        };

        user = mkOption {
          default = defaultUser;
          example = "yourUser";
          description = ''
            The user to run vscodium-server as.
            By default, a user named `${defaultUser}` will be created.
          '';
          type = str;
        };

        group = mkOption {
          default = defaultGroup;
          example = "yourGroup";
          description = ''
            The group to run vscodium-server under.
            By default, a group named `${defaultGroup}` will be created.
          '';
          type = str;
        };

        extraGroups = mkOption {
          default = [ ];
          description = ''
            An array of additional groups for the `${defaultUser}` user.
          '';
          example = [ "docker" ];
          type = listOf str;
        };

        withoutConnectionToken = mkOption {
          default = false;
          description = ''
            Run without a connection token. Only use this if the connection is secured by other means.
          '';
          example = true;
          type = bool;
        };

        socketPath = mkOption {
          default = null;
          example = "/run/vscodium/socket";
          description = ''
            The path to a socket file for the server to listen to.
          '';
          type = nullOr str;
        };

        userDataDir = mkOption {
          default = null;
          description = ''
            Specifies the directory that user data is kept in. Can be used to open multiple distinct instances of Code.
          '';
          type = nullOr str;
        };

        serverDataDir = mkOption {
          default = null;
          description = ''
            Specifies the directory that server data is kept in.
          '';
          type = nullOr str;
        };

        extensionsDir = mkOption {
          default = null;
          description = ''
            Set the root path for extensions.
          '';
          type = nullOr str;
        };

        telemetryLevel = mkOption {
          default = null;
          example = "crash";
          description = ''
            Sets the initial telemetry level. Valid levels are: 'off', 'crash', 'error' and 'all'.
          '';
          type = nullOr (enum [
            "off"
            "crash"
            "error"
            "all"
          ]);
        };

        connectionToken = mkOption {
          default = null;
          example = "secret-token";
          description = ''
            A secret that must be included with all requests.
          '';
          type = nullOr str;
        };

        connectionTokenFile = mkOption {
          default = null;
          description = ''
            Path to a file that contains the connection token.
          '';
          type = nullOr str;
        };

      };
    };

  config = lib.mkIf cfg.enable {
    systemd.services.vscodium-server = {
      description = "VSCodium server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      path = cfg.extraPackages;
      environment = cfg.extraEnvironment;
      serviceConfig = {
        ExecStart = ''
          ${cfg.binary} \
            --host=${cfg.host} \
            --port=${toString cfg.port} \
        ''
        + lib.optionalString (cfg.telemetryLevel != null) ''
          --telemetry-level=${cfg.telemetryLevel} \
        ''
        + lib.optionalString (cfg.withoutConnectionToken) ''
          --without-connection-token \
        ''
        + lib.optionalString (cfg.socketPath != null) ''
          --socket-path=${cfg.socketPath} \
        ''
        + lib.optionalString (cfg.userDataDir != null) ''
          --user-data-dir=${cfg.userDataDir} \
        ''
        + lib.optionalString (cfg.serverDataDir != null) ''
          --server-data-dir=${cfg.serverDataDir} \
        ''
        + lib.optionalString (cfg.extensionsDir != null) ''
          --extensions-dir=${cfg.extensionsDir} \
        ''
        + lib.optionalString (cfg.connectionToken != null) ''
          --connection-token=${cfg.connectionToken} \
        ''
        + lib.optionalString (cfg.connectionTokenFile != null) ''
          --connection-token-file=${cfg.connectionTokenFile} \
        ''
        + lib.escapeShellArgs cfg.extraArguments;
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        RuntimeDirectory = cfg.user;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };
    };

    users.users."${cfg.user}" = {
      isNormalUser = true;
      description = "vscodium-server user";
      inherit (cfg) group;
      packages = cfg.extraPackages;
      inherit (cfg) extraGroups;
    };

    users.groups."${defaultGroup}" = lib.mkIf (cfg.group == defaultGroup) { };
  };

  meta.maintainers = [ ];
}
