{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.types) package str;
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    ;
  cfg = config.services.dashy;
in
{
  options.services.dashy = {
    enable = mkEnableOption ''
      Dashy, a highly customizable, easy to use, privacy-respecting dashboard app.

      Note that this builds a static web app as opposed to running a full node server, unlike the default docker image.

      Writing config changes to disk through the UI, triggering a rebuild through the UI and application status checks are
      unavailable without the node server; Everything else will work fine.

      See the deployment docs for [building from source](https://dashy.to/docs/deployment#build-from-source), [hosting with a CDN](https://dashy.to/docs/deployment#hosting-with-cdn) and [CDN cloud deploy](https://dashy.to/docs/deployment#cdn--cloud-deploy) for more information.
    '';

    virtualHost = {
      enableNginx = mkEnableOption "a virtualhost to serve dashy through nginx";

      domain = mkOption {
        description = ''
          Domain to use for the virtual host.

          This can be used to change nginx options like
          ```nix
          services.nginx.virtualHosts."$\{config.services.dashy.virtualHost.domain}".listen = [ ... ]
          ```
          or
          ```nix
          services.nginx.virtualHosts."example.com".listen = [ ... ]
          ```
        '';
        type = str;
      };
    };

    package = mkPackageOption pkgs "dashy-ui" { };

    finalDrv = mkOption {
      readOnly = true;
      default =
        if cfg.settings != { } then cfg.package.override { inherit (cfg) settings; } else cfg.package;
      defaultText = ''
        if cfg.settings != {}
        then cfg.package.override {inherit (cfg) settings;}
        else cfg.package;
      '';
      type = package;
      description = ''
        Final derivation containing the fully built static files
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        Settings serialized into `user-data/conf.yml` before build.
        If left empty, the default configuration shipped with the package will be used instead.

        Note that the full configuration will be written to the nix store as world readable, which may include secrets such as [password hashes](https://dashy.to/docs/configuring#appconfigauthusers-optional).

        To add files such as icons or backgrounds, you can reference them in line such as
        ```nix
        icon = "$\{./icon.png}";
        ```
        This will add the file to the nix store upon build, referencing it by file path as expected by Dashy.
      '';
      example = ''
        {
          appConfig = {
            cssThemes = [
              "example-theme-1"
              "example-theme-2"
            ];
            enableFontAwesome = true;
            fontAwesomeKey = "e9076c7025";
            theme = "thebe";
          };
          pageInfo = {
            description = "My Awesome Dashboard";
            navLinks = [
              {
                path = "/";
                title = "Home";
              }
              {
                path = "https://example.com";
                title = "Example 1";
              }
              {
                path = "https://example.com";
                title = "Example 2";
              }
            ];
            title = "Dashy";
          };
          sections = [
            {
              displayData = {
                collapsed = true;
                cols = 2;
                customStyles = "border: 2px dashed red;";
                itemSize = "large";
              };
              items = [
                {
                  backgroundColor = "#0079ff";
                  color = "#00ffc9";
                  description = "Source code and documentation on GitHub";
                  icon = "fab fa-github";
                  target = "sametab";
                  title = "Source";
                  url = "https://github.com/Lissy93/dashy";
                }
                {
                  description = "View currently open issues, or raise a new one";
                  icon = "fas fa-bug";
                  title = "Issues";
                  url = "https://github.com/Lissy93/dashy/issues";
                }
                {
                  description = "Live Demo #1";
                  icon = "fas fa-rocket";
                  target = "iframe";
                  title = "Demo 1";
                  url = "https://dashy-demo-1.as93.net";
                }
                {
                  description = "Live Demo #2";
                  icon = "favicon";
                  target = "newtab";
                  title = "Demo 2";
                  url = "https://dashy-demo-2.as93.net";
                }
              ];
              name = "Getting Started";
            }
          ];
        }
      '';
      inherit (pkgs.formats.json { }) type;
    };
  };

  config = mkIf cfg.enable {
    services.nginx = mkIf cfg.virtualHost.enableNginx {
      enable = true;
      virtualHosts."${cfg.virtualHost.domain}" = {
        locations."/" = {
          root = cfg.finalDrv;
          tryFiles = "$uri /index.html ";
        };
      };
    };
  };

  meta.maintainers = [
    lib.maintainers.therealgramdalf
  ];
}
