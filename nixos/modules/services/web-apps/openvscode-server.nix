{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.openvscode-server;
  defaultUser = "openvscode-server";
  defaultGroup = defaultUser;
in
{
  options = {
    services.openvscode-server = {
      enable = lib.mkEnableOption "openvscode-server";

      package = lib.mkPackageOption pkgs "openvscode-server" { };

      extraPackages = lib.mkOption {
        default = [ ];
        description = ''
          Additional packages to add to the openvscode-server {env}`PATH`.
        '';
        example = lib.literalExpression "[ pkgs.go ]";
        type = lib.types.listOf lib.types.package;
      };

      extraEnvironment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = ''
          Additional environment variables to pass to openvscode-server.
        '';
        default = { };
        example = {
          PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
        };
      };

      extraArguments = lib.mkOption {
        default = [ ];
        description = ''
          Additional arguments to pass to openvscode-server.
        '';
        example = lib.literalExpression ''[ "--log=info" ]'';
        type = lib.types.listOf lib.types.str;
      };

      host = lib.mkOption {
        default = "localhost";
        description = ''
          The host name or IP address the server should listen to.
        '';
        type = lib.types.str;
      };

      port = lib.mkOption {
        default = 3000;
        description = ''
          The port the server should listen to. If 0 is passed a random free port is picked. If a range in the format num-num is passed, a free port from the range (end inclusive) is selected.
        '';
        type = lib.types.port;
      };

      user = lib.mkOption {
        default = defaultUser;
        example = "yourUser";
        description = ''
          The user to run openvscode-server as.
          By default, a user named `${defaultUser}` will be created.
        '';
        type = lib.types.str;
      };

      group = lib.mkOption {
        default = defaultGroup;
        example = "yourGroup";
        description = ''
          The group to run openvscode-server under.
          By default, a group named `${defaultGroup}` will be created.
        '';
        type = lib.types.str;
      };

      extraGroups = lib.mkOption {
        default = [ ];
        description = ''
          An array of additional groups for the `${defaultUser}` user.
        '';
        example = [ "docker" ];
        type = lib.types.listOf lib.types.str;
      };

      withoutConnectionToken = lib.mkOption {
        default = false;
        description = ''
          Run without a connection token. Only use this if the connection is secured by other means.
        '';
        example = true;
        type = lib.types.bool;
      };

      socketPath = lib.mkOption {
        default = null;
        example = "/run/openvscode/socket";
        description = ''
          The path to a socket file for the server to listen to.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      userDataDir = lib.mkOption {
        default = null;
        description = ''
          Specifies the directory that user data is kept in. Can be used to open multiple distinct instances of Code.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      serverDataDir = lib.mkOption {
        default = null;
        description = ''
          Specifies the directory that server data is kept in.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      extensionsDir = lib.mkOption {
        default = null;
        description = ''
          Set the root path for extensions.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      telemetryLevel = lib.mkOption {
        default = null;
        example = "crash";
        description = ''
          Sets the initial telemetry level. Valid levels are: 'off', 'crash', 'error' and 'all'.
        '';
        type = lib.types.nullOr (
          lib.types.enum [
            "off"
            "crash"
            "error"
            "all"
          ]
        );
      };

      connectionToken = lib.mkOption {
        default = null;
        example = "secret-token";
        description = ''
          A secret that must be included with all requests.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      connectionTokenFile = lib.mkOption {
        default = null;
        description = ''
          Path to a file that contains the connection token.
        '';
        type = lib.types.nullOr lib.types.str;
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.openvscode-server = {
      description = "OpenVSCode server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      path = cfg.extraPackages;
      environment = cfg.extraEnvironment;
      serviceConfig = {
        ExecStart =
          ''
            ${lib.getExe cfg.package} \
              --accept-server-license-terms \
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

    users.users."${cfg.user}" = lib.mkMerge [
      (lib.mkIf (cfg.user == defaultUser) {
        isNormalUser = true;
        description = "openvscode-server user";
        inherit (cfg) group;
      })
      {
        packages = cfg.extraPackages;
        inherit (cfg) extraGroups;
      }
    ];

    users.groups."${defaultGroup}" = lib.mkIf (cfg.group == defaultGroup) { };
  };

  meta.maintainers = [ lib.maintainers.drupol ];
}
