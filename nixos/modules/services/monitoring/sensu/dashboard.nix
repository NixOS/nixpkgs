{ config, lib, cfg }:

{
  options = with lib; with types; {
    enable = mkOption {
      type = bool;
      default = (cfg.role == "server");
      description = "Enable the dashboard";
    };

    host = mkOption {
      type = str;
      default = "127.0.0.1";
      description = "The IP address on which Uchiwa will listen.";
    };

    port = mkOption {
      type = int;
      default = 3000;
      description = "The port on which Uchiwa will listen.";
    };

    refresh = mkOption {
      type = int;
      default = 5;
      description = "UI refresh interval.";
    };

    proxy = mkOption {
      description = "Proxy traffic to/from the sensu dashboard.";
      default = {};
      type = submodule {
        options = {
          enable = mkOption {
            type = bool;
            default = false;
            description = "Enable proxy.";
          };

          path = mkOption {
            type = str;
            default = "/";
            description = "The path to the dashboard if behind a proxy.";
          };

          name = mkOption {
            type = str;
            default = config.networking.hostName;
            description = "Hostname on which to repond.";
          };

          enableSSL = mkOption {
            type = bool;
            default = false;
            description = "Force SSL.";
          };
        };
      };
    };

    users = mkOption {
      description = "Users";
      default = {};
      type = listOf(submodule {
        options = {
          username = mkOption {
            description = "User name.";
            type = str;
          };

          password = mkOption {
            description = "Password.";
            type = str;
          };

          accessToken = mkOption {
            default = "";
            description = "Access token.";
            type = str;
          };

          readonly = mkOption {
            default = false;
            description = "Read only.";
            type = bool;
          };
        };
      });
    };

    usersOptions = mkOption {
      description = "Options relevant to all users";
      default = {};
      type = submodule {
        options = {

          defaultTheme = mkOption {
            type = enum [ "uchiwa-default" "uchiwa-dark" ];
            default = "uchiwa-dark";
            description = "The theme to use.";
          };

          logoUrl = mkOption {
            type = str;
            default = "";
            description = "The logo to use.";
          };
        };
      };
    };
  };
}
