{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.services.code-server;
  defaultUser = "code-server";
  defaultGroup = defaultUser;

in {
  ###### interface
  options = {
    services.code-server = {
      enable = mkEnableOption "code-server";

      package = mkOption {
        default = pkgs.code-server;
        defaultText = "pkgs.code-server";
        description = "Which code-server derivation to use.";
        type = types.package;
      };

      extraPackages = mkOption {
        default = [ ];
        description = "Packages that are available in the PATH of code-server.";
        example = "[ pkgs.go ]";
        type = types.listOf types.package;
      };

      extraEnvironment = mkOption {
        type = types.attrsOf types.str;
        description =
          "Additional environment variables to passed to code-server.";
        default = { };
        example = { PKG_CONFIG_PATH = "/run/current-system/sw/lib/pkgconfig"; };
      };

      extraArguments = mkOption {
        default = [ "--disable-telemetry" ];
        description = "Additional arguments that passed to code-server";
        example = ''[ "--verbose" ]'';
        type = types.listOf types.str;
      };

      host = mkOption {
        default = "127.0.0.1";
        description = "The host-ip to bind to.";
        type = types.str;
      };

      port = mkOption {
        default = 4444;
        description = "The port where code-server runs.";
        type = types.port;
      };

      auth = mkOption {
        default = "password";
        description = "The type of authentication to use.";
        type = types.enum [ "none" "password" ];
      };

      hashedPassword = mkOption {
        default = "";
        description =
          "Create the password with: 'echo -n 'thisismypassword' | npx argon2-cli -e'.";
        type = types.str;
      };

      user = mkOption {
        default = defaultUser;
        example = "yourUser";
        description = ''
          The user to run code-server as.
          By default, a user named <literal>${defaultUser}</literal> will be created.
        '';
        type = types.str;
      };

      group = mkOption {
        default = defaultGroup;
        example = "yourGroup";
        description = ''
          The group to run code-server under.
          By default, a group named <literal>${defaultGroup}</literal> will be created.
        '';
        type = types.str;
      };

      extraGroups = mkOption {
        default = [ ];
        description =
          "An array of additional groups for the <literal>${defaultUser}</literal> user.";
        example = [ "docker" ];
        type = types.listOf types.str;
      };

    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    systemd.services.code-server = {
      description = "VSCode server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      path = cfg.extraPackages;
      environment = {
        HASHED_PASSWORD = cfg.hashedPassword;
      } // cfg.extraEnvironment;
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/code-server --bind-addr ${cfg.host}:${toString cfg.port} --auth ${cfg.auth} " + builtins.concatStringsSep " " cfg.extraArguments;
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        RuntimeDirectory = cfg.user;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };

    };

    users.users."${cfg.user}" = mkMerge [
      (mkIf (cfg.user == defaultUser) {
        isNormalUser = true;
        description = "code-server user";
        inherit (cfg) group;
      })
      {
        packages = cfg.extraPackages;
        inherit (cfg) extraGroups;
      }
    ];

    users.groups."${defaultGroup}" = mkIf (cfg.group == defaultGroup) { };

  };

  meta.maintainers = with maintainers; [ stackshadow ];
}
