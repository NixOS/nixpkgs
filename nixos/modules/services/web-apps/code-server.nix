{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.code-server;
  defaultUser = "code-server";
  defaultGroup = defaultUser;
in
{
  options = {
    services.code-server = {
      enable = lib.mkEnableOption "code-server";

      package = lib.mkPackageOption pkgs "code-server" {
        example = ''
          pkgs.vscode-with-extensions.override {
            vscode = pkgs.code-server;
            vscodeExtensions = with pkgs.vscode-extensions; [
              bbenoist.nix
              dracula-theme.theme-dracula
            ];
          }
        '';
      };

      extraPackages = lib.mkOption {
        default = [ ];
        description = ''
          Additional packages to add to the code-server {env}`PATH`.
        '';
        example = lib.literalExpression "[ pkgs.go ]";
        type = lib.types.listOf lib.types.package;
      };

      extraEnvironment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = ''
          Additional environment variables to pass to code-server.
        '';
        default = { };
        example = {
          PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig";
        };
      };

      extraArguments = lib.mkOption {
        default = [ ];
        description = ''
          Additional arguments to pass to code-server.
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
        default = 4444;
        description = ''
          The port the server should listen to.
        '';
        type = lib.types.port;
      };

      auth = lib.mkOption {
        default = "password";
        description = ''
          The type of authentication to use.
        '';
        type = lib.types.enum [
          "none"
          "password"
        ];
      };

      hashedPassword = lib.mkOption {
        default = "";
        description = ''
          Create the password with: {command}`echo -n 'thisismypassword' | nix run nixpkgs#libargon2 -- "$(head -c 20 /dev/random | base64)" -e`
        '';
        type = lib.types.str;
      };

      user = lib.mkOption {
        default = defaultUser;
        example = "yourUser";
        description = ''
          The user to run code-server as.
          By default, a user named `${defaultUser}` will be created.
        '';
        type = lib.types.str;
      };

      group = lib.mkOption {
        default = defaultGroup;
        example = "yourGroup";
        description = ''
          The group to run code-server under.
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

      socket = lib.mkOption {
        default = null;
        example = "/run/code-server/socket";
        description = ''
          Path to a socket (bind-addr will be ignored).
        '';
        type = lib.types.nullOr lib.types.str;
      };

      socketMode = lib.mkOption {
        default = null;
        description = ''
          File mode of the socket.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      userDataDir = lib.mkOption {
        default = null;
        description = ''
          Path to the user data directory.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      extensionsDir = lib.mkOption {
        default = null;
        description = ''
          Path to the extensions directory.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      proxyDomain = lib.mkOption {
        default = null;
        example = "code-server.lan";
        description = ''
          Domain used for proxying ports.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      disableTelemetry = lib.mkOption {
        default = false;
        example = true;
        description = ''
          Disable telemetry.
        '';
        type = lib.types.bool;
      };

      disableUpdateCheck = lib.mkOption {
        default = false;
        example = true;
        description = ''
          Disable update check.
          Without this flag, code-server checks every 6 hours against the latest github release and
          then notifies you once every week that a new release is available.
        '';
        type = lib.types.bool;
      };

      disableFileDownloads = lib.mkOption {
        default = false;
        example = true;
        description = ''
          Disable file downloads from Code.
        '';
        type = lib.types.bool;
      };

      disableWorkspaceTrust = lib.mkOption {
        default = false;
        example = true;
        description = ''
          Disable Workspace Trust feature.
        '';
        type = lib.types.bool;
      };

      disableGettingStartedOverride = lib.mkOption {
        default = false;
        example = true;
        description = ''
          Disable the coder/coder override in the Help: Getting Started page.
        '';
        type = lib.types.bool;
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.code-server = {
      description = "Code server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      path = cfg.extraPackages;
      environment = {
        HASHED_PASSWORD = cfg.hashedPassword;
      }
      // cfg.extraEnvironment;
      serviceConfig = {
        ExecStart = ''
          ${lib.getExe cfg.package} \
            --auth=${cfg.auth} \
            --bind-addr=${cfg.host}:${toString cfg.port} \
        ''
        + lib.optionalString (cfg.socket != null) ''
          --socket=${cfg.socket} \
        ''
        + lib.optionalString (cfg.socketMode != null) ''
          --socket-mode=${cfg.socketMode} \
        ''
        + lib.optionalString (cfg.userDataDir != null) ''
          --user-data-dir=${cfg.userDataDir} \
        ''
        + lib.optionalString (cfg.extensionsDir != null) ''
          --extensions-dir=${cfg.extensionsDir} \
        ''
        + lib.optionalString (cfg.disableTelemetry == true) ''
          --disable-telemetry \
        ''
        + lib.optionalString (cfg.disableUpdateCheck == true) ''
          --disable-update-check \
        ''
        + lib.optionalString (cfg.disableFileDownloads == true) ''
          --disable-file-downloads \
        ''
        + lib.optionalString (cfg.disableWorkspaceTrust == true) ''
          --disable-workspace-trust \
        ''
        + lib.optionalString (cfg.disableGettingStartedOverride == true) ''
          --disable-getting-started-override \
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
        description = "code-server user";
        inherit (cfg) group;
      })
      {
        packages = cfg.extraPackages;
        inherit (cfg) extraGroups;
      }
    ];

    users.groups."${defaultGroup}" = lib.mkIf (cfg.group == defaultGroup) { };
  };

  meta.maintainers = [ lib.maintainers.stackshadow ];
}
