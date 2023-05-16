{ config, lib, pkgs, ... }:

<<<<<<< HEAD
let
  cfg = config.services.code-server;
  defaultUser = "code-server";
  defaultGroup = defaultUser;
in {
  options = {
    services.code-server = {
      enable = lib.mkEnableOption (lib.mdDoc "code-server");

      package = lib.mkPackageOptionMD pkgs "code-server" {
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
        description = lib.mdDoc ''
          Additional packages to add to the code-server {env}`PATH`.
        '';
        example = lib.literalExpression "[ pkgs.go ]";
        type = lib.types.listOf lib.types.package;
      };

      extraEnvironment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = lib.mdDoc ''
          Additional environment variables to pass to code-server.
        '';
=======
with lib;
let

  cfg = config.services.code-server;
  defaultUser = "code-server";
  defaultGroup = defaultUser;

in {
  ###### interface
  options = {
    services.code-server = {
      enable = mkEnableOption (lib.mdDoc "code-server");

      package = mkOption {
        default = pkgs.code-server;
        defaultText = lib.literalExpression "pkgs.code-server";
        description = lib.mdDoc "Which code-server derivation to use.";
        type = types.package;
      };

      extraPackages = mkOption {
        default = [ ];
        description = lib.mdDoc "Packages that are available in the PATH of code-server.";
        example = "[ pkgs.go ]";
        type = types.listOf types.package;
      };

      extraEnvironment = mkOption {
        type = types.attrsOf types.str;
        description =
          lib.mdDoc "Additional environment variables to passed to code-server.";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        default = { };
        example = { PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig"; };
      };

<<<<<<< HEAD
      extraArguments = lib.mkOption {
        default = [ ];
        description = lib.mdDoc ''
          Additional arguments to pass to code-server.
        '';
        example = lib.literalExpression ''[ "--log=info" ]'';
        type = lib.types.listOf lib.types.str;
      };

      host = lib.mkOption {
        default = "localhost";
        description = lib.mdDoc ''
          The host name or IP address the server should listen to.
        '';
        type = lib.types.str;
      };

      port = lib.mkOption {
        default = 4444;
        description = lib.mdDoc ''
          The port the server should listen to.
        '';
        type = lib.types.port;
      };

      auth = lib.mkOption {
        default = "password";
        description = lib.mdDoc ''
          The type of authentication to use.
        '';
        type = lib.types.enum [ "none" "password" ];
      };

      hashedPassword = lib.mkOption {
        default = "";
        description = lib.mdDoc ''
          Create the password with: `echo -n 'thisismypassword' | npx argon2-cli -e`.
        '';
        type = lib.types.str;
      };

      user = lib.mkOption {
=======
      extraArguments = mkOption {
        default = [ "--disable-telemetry" ];
        description = lib.mdDoc "Additional arguments that passed to code-server";
        example = ''[ "--verbose" ]'';
        type = types.listOf types.str;
      };

      host = mkOption {
        default = "127.0.0.1";
        description = lib.mdDoc "The host-ip to bind to.";
        type = types.str;
      };

      port = mkOption {
        default = 4444;
        description = lib.mdDoc "The port where code-server runs.";
        type = types.port;
      };

      auth = mkOption {
        default = "password";
        description = lib.mdDoc "The type of authentication to use.";
        type = types.enum [ "none" "password" ];
      };

      hashedPassword = mkOption {
        default = "";
        description =
          lib.mdDoc "Create the password with: `echo -n 'thisismypassword' | npx argon2-cli -e`.";
        type = types.str;
      };

      user = mkOption {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        default = defaultUser;
        example = "yourUser";
        description = lib.mdDoc ''
          The user to run code-server as.
          By default, a user named `${defaultUser}` will be created.
        '';
<<<<<<< HEAD
        type = lib.types.str;
      };

      group = lib.mkOption {
=======
        type = types.str;
      };

      group = mkOption {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        default = defaultGroup;
        example = "yourGroup";
        description = lib.mdDoc ''
          The group to run code-server under.
          By default, a group named `${defaultGroup}` will be created.
        '';
<<<<<<< HEAD
        type = lib.types.str;
      };

      extraGroups = lib.mkOption {
        default = [ ];
        description = lib.mdDoc ''
          An array of additional groups for the `${defaultUser}` user.
        '';
        example = [ "docker" ];
        type = lib.types.listOf lib.types.str;
      };

      socket = lib.mkOption {
        default = null;
        example = "/run/code-server/socket";
        description = lib.mdDoc ''
          Path to a socket (bind-addr will be ignored).
        '';
        type = lib.types.nullOr lib.types.str;
      };

      socketMode = lib.mkOption {
        default = null;
        description = lib.mdDoc ''
           File mode of the socket.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      userDataDir = lib.mkOption {
        default = null;
        description = lib.mdDoc ''
          Path to the user data directory.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      extensionsDir = lib.mkOption {
        default = null;
        description = lib.mdDoc ''
          Path to the extensions directory.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      proxyDomain = lib.mkOption {
        default = null;
        example = "code-server.lan";
        description = lib.mdDoc ''
          Domain used for proxying ports.
        '';
        type = lib.types.nullOr lib.types.str;
      };

      disableTelemetry = lib.mkOption {
        default = false;
        example = true;
        description = lib.mdDoc ''
          Disable telemetry.
        '';
        type = lib.types.bool;
      };

      disableUpdateCheck = lib.mkOption {
        default = false;
        example = true;
        description = lib.mdDoc ''
          Disable update check.
          Without this flag, code-server checks every 6 hours against the latest github release and
          then notifies you once every week that a new release is available.
        '';
        type = lib.types.bool;
      };

      disableFileDownloads = lib.mkOption {
        default = false;
        example = true;
        description = lib.mdDoc ''
          Disable file downloads from Code.
        '';
        type = lib.types.bool;
      };

      disableWorkspaceTrust = lib.mkOption {
        default = false;
        example = true;
        description = lib.mdDoc ''
          Disable Workspace Trust feature.
        '';
        type = lib.types.bool;
      };

      disableGettingStartedOverride = lib.mkOption {
        default = false;
        example = true;
        description = lib.mdDoc ''
          Disable the coder/coder override in the Help: Getting Started page.
        '';
        type = lib.types.bool;
=======
        type = types.str;
      };

      extraGroups = mkOption {
        default = [ ];
        description =
          lib.mdDoc "An array of additional groups for the `${defaultUser}` user.";
        example = [ "docker" ];
        type = types.listOf types.str;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

    };
  };

<<<<<<< HEAD
  config = lib.mkIf cfg.enable {
    systemd.services.code-server = {
      description = "Code server";
=======
  ###### implementation
  config = mkIf cfg.enable {
    systemd.services.code-server = {
      description = "VSCode server";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      path = cfg.extraPackages;
      environment = {
        HASHED_PASSWORD = cfg.hashedPassword;
      } // cfg.extraEnvironment;
      serviceConfig = {
<<<<<<< HEAD
        ExecStart = ''
          ${lib.getExe cfg.package} \
            --auth=${cfg.auth} \
            --bind-addr=${cfg.host}:${toString cfg.port} \
          '' + lib.optionalString (cfg.socket != null) ''
            --socket=${cfg.socket} \
          '' + lib.optionalString (cfg.userDataDir != null) ''
            --user-data-dir=${cfg.userDataDir} \
          '' + lib.optionalString (cfg.extensionsDir != null) ''
            --extensions-dir=${cfg.extensionsDir} \
          '' + lib.optionalString (cfg.disableTelemetry == true) ''
            --disable-telemetry \
          '' + lib.optionalString (cfg.disableUpdateCheck == true) ''
            --disable-update-check \
          '' + lib.optionalString (cfg.disableFileDownloads == true) ''
            --disable-file-downloads \
          '' + lib.optionalString (cfg.disableWorkspaceTrust == true) ''
            --disable-workspace-trust \
          '' + lib.optionalString (cfg.disableGettingStartedOverride == true) ''
            --disable-getting-started-override \
          '' + lib.escapeShellArgs cfg.extraArguments;
=======
        ExecStart = "${cfg.package}/bin/code-server --bind-addr ${cfg.host}:${toString cfg.port} --auth ${cfg.auth} " + lib.escapeShellArgs cfg.extraArguments;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        RuntimeDirectory = cfg.user;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };
<<<<<<< HEAD
    };

    users.users."${cfg.user}" = lib.mkMerge [
      (lib.mkIf (cfg.user == defaultUser) {
=======

    };

    users.users."${cfg.user}" = mkMerge [
      (mkIf (cfg.user == defaultUser) {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        isNormalUser = true;
        description = "code-server user";
        inherit (cfg) group;
      })
      {
        packages = cfg.extraPackages;
        inherit (cfg) extraGroups;
      }
    ];

<<<<<<< HEAD
    users.groups."${defaultGroup}" = lib.mkIf (cfg.group == defaultGroup) { };
  };

  meta.maintainers = [ lib.maintainers.stackshadow ];
=======
    users.groups."${defaultGroup}" = mkIf (cfg.group == defaultGroup) { };

  };

  meta.maintainers = with maintainers; [ stackshadow ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
