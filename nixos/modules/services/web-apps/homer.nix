{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.homer;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "homer-config.yml" cfg.settings;
in
{
  options.services.homer = {
    enable = lib.mkEnableOption ''
      A dead simple static HOMepage for your servER to keep your services on hand, from a simple yaml configuration file.
    '';

    virtualHost = {
      nginx.enable = lib.mkEnableOption "a virtualhost to serve homer through nginx";
      caddy.enable = lib.mkEnableOption "a virtualhost to serve homer through caddy";

      domain = lib.mkOption {
        description = ''
          Domain to use for the virtual host.

          This can be used to change nginx options like
          ```nix
          services.nginx.virtualHosts."$\{config.services.homer.virtualHost.domain}".listen = [ ... ]
          ```
          or
          ```nix
          services.nginx.virtualHosts."example.com".listen = [ ... ]
          ```
        '';
        type = lib.types.str;
      };
    };

    package = lib.mkPackageOption pkgs "homer" { };

    settings = lib.mkOption {
      default = { };
      description = ''
        Settings serialized into `config.yml` before build.
        If left empty, the default configuration shipped with the package will be used instead.
        For more information, see the [official documentation](https://github.com/bastienwirtz/homer/blob/main/docs/configuration.md).

        Note that the full configuration will be written to the nix store as world readable, which may include secrets such as [api-keys](https://github.com/bastienwirtz/homer/blob/main/docs/customservices.md).

        To add files such as icons or backgrounds, you can reference them in line such as
        ```nix
        icon = "''${./icon.png}";
        ```
        This will add the file to the nix store upon build, referencing it by file path as expected by Homer.
      '';
      example = ''
        {
          title = "App dashboard";
          subtitle = "Homer";
          logo = "assets/logo.png";
          header = true;
          footer = ${"''"}
            <p>Created with <span class="has-text-danger">❤️</span> with
            <a href="https://bulma.io/">bulma</a>,
            <a href="https://vuejs.org/">vuejs</a> &
            <a href="https://fontawesome.com/">font awesome</a> //
            Fork me on <a href="https://github.com/bastienwirtz/homer">
            <i class="fab fa-github-alt"></i></a></p>
          ${"''"};
          columns = "3";
          connectivityCheck = true;

          proxy = {
            useCredentials = false;
            headers = {
              Test = "Example";
              Test1 = "Example1";
            };
          };

          defaults = {
            layout = "columns";
            colorTheme = "auto";
          };

          theme = "default";

          message = {
            style = "is-warning";
            title = "Optional message!";
            icon = "fa fa-exclamation-triangle";
            content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";
          };

          links = [
            {
              name = "Link 1";
              icon = "fab fa-github";
              url = "https://github.com/bastienwirtz/homer";
              target = "_blank";
            }
            {
              name = "link 2";
              icon = "fas fa-book";
              url = "https://github.com/bastienwirtz/homer";
            }
          ];

          services = [
            {
              name = "Application";
              icon = "fas fa-code-branch";
              items = [
                {
                  name = "Awesome app";
                  logo = "assets/tools/sample.png";
                  subtitle = "Bookmark example";
                  tag = "app";
                  keywords = "self hosted reddit";
                  url = "https://www.reddit.com/r/selfhosted/";
                  target = "_blank";
                }
                {
                  name = "Another one";
                  logo = "assets/tools/sample2.png";
                  subtitle = "Another application";
                  tag = "app";
                  tagstyle = "is-success";
                  url = "#";
                }
              ];
            }
            {
              name = "Other group";
              icon = "fas fa-heartbeat";
              items = [
                {
                  name = "Pi-hole";
                  logo = "assets/tools/sample.png";
                  tag = "other";
                  url = "http://192.168.0.151/admin";
                  type = "PiHole";
                  target = "_blank";
                }
              ];
            }
          ];
        }

      '';
      inherit (pkgs.formats.yaml { }) type;
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = lib.mkIf cfg.virtualHost.nginx.enable {
      enable = true;
      virtualHosts."${cfg.virtualHost.domain}" = {
        locations."/" = {
          root = cfg.package;
          tryFiles = "$uri /index.html";
        };
        locations."= /assets/config.yml" = {
          alias = configFile;
        };
      };
    };
    services.caddy = lib.mkIf cfg.virtualHost.caddy.enable {
      enable = true;
      virtualHosts."${cfg.virtualHost.domain}".extraConfig = ''
        root * ${cfg.package}
        file_server
        handle_path /assets/config.yml {
          root * ${configFile}
          file_server
        }
      '';
    };
  };

  meta.maintainers = [
    lib.maintainers.stunkymonkey
  ];
}
