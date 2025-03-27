{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    mkDefault
    types
    concatMapStringsSep
    generators
    ;
  cfg = config.services.open-web-calendar;

  nixosSpec = calendarSettingsFormat.generate "nixos_specification.json" cfg.calendarSettings;
  finalPackage = cfg.package.override {
    # The calendarSettings need to be merged with the default_specification.yml
    # in the source. This way we use upstreams default values but keep everything overridable.
    defaultSpecificationFile = pkgs.runCommand "custom-default_specification.yml" { } ''
      ${pkgs.yq}/bin/yq -s '.[0] * .[1]' ${cfg.package}/${cfg.package.defaultSpecificationPath} ${nixosSpec} > $out
    '';
  };

  inherit (finalPackage) python;
  pythonEnv = python.buildEnv.override {
    extraLibs = [
      (python.pkgs.toPythonModule finalPackage)
      # Allows Gunicorn to set a meaningful process name
      python.pkgs.gunicorn.optional-dependencies.setproctitle
    ];
  };

  settingsFormat = pkgs.formats.keyValue { };
  calendarSettingsFormat = pkgs.formats.json { };
in
{
  options.services.open-web-calendar = {

    enable = mkEnableOption "OpenWebCalendar service";

    package = mkPackageOption pkgs "open-web-calendar" { };

    domain = mkOption {
      type = types.str;
      description = "The domain under which open-web-calendar is made available";
      example = "open-web-calendar.example.org";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          ALLOWED_HOSTS = mkOption {
            type = types.str;
            readOnly = true;
            description = ''
              The hosts that the Open Web Calendar permits. This is required to
              mitigate the Host Header Injection vulnerability.

              We always set this to the empty list, as Nginx already checks the Host header.
            '';
            default = "";
          };
        };
      };
      default = { };
      description = ''
        Configuration for the server. These are set as environment variables to the gunicorn/flask service.

        See the documentation options in <https://open-web-calendar.quelltext.eu/host/configure/#configuring-the-server>.
      '';
    };

    calendarSettings = mkOption {
      type = types.submodule {
        freeformType = calendarSettingsFormat.type;
        options = { };
      };
      default = { };
      description = ''
        Configure the default calendar.

        See the documentation options in <https://open-web-calendar.quelltext.eu/host/configure/#configuring-the-default-calendar> and <https://github.com/niccokunzmann/open-web-calendar/blob/master/open_web_calendar/default_specification.yml>.

        Individual calendar instances can be further configured outside this module, by specifying the `specification_url` parameter.
      '';
    };

  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = !cfg.settings ? "PORT";
        message = ''
          services.open-web-calendar.settings.PORT can't be set, as the service uses a unix socket.
        '';
      }
    ];

    systemd.sockets.open-web-calendar = {
      before = [ "nginx.service" ];
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "/run/open-web-calendar/socket";
        SocketUser = "open-web-calendar";
        SocketGroup = "open-web-calendar";
        SocketMode = "770";
      };
    };

    systemd.services.open-web-calendar = {
      description = "Open Web Calendar";
      after = [ "network.target" ];
      environment.PYTHONPATH = "${pythonEnv}/${python.sitePackages}/";
      serviceConfig = {
        Type = "notify";
        NotifyAccess = "all";
        ExecStart = ''
          ${pythonEnv.pkgs.gunicorn}/bin/gunicorn \
            --name=open-web-calendar \
            --bind='unix:///run/open-web-calendar/socket' \
            open_web_calendar.app:app
        '';
        EnvironmentFile = settingsFormat.generate "open-web-calendar.env" cfg.settings;
        ExecReload = "kill -s HUP $MAINPID";
        KillMode = "mixed";
        PrivateTmp = true;
        RuntimeDirectory = "open-web-calendar";
        User = "open-web-calendar";
        Group = "open-web-calendar";
      };
    };

    users.users.open-web-calendar = {
      isSystemUser = true;
      group = "open-web-calendar";
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.domain}" = {
        forceSSL = mkDefault true;
        enableACME = mkDefault true;
        locations."/".proxyPass = "http://unix:///run/open-web-calendar/socket";
      };
    };

    users.groups.open-web-calendar.members = [ config.services.nginx.user ];

  };

  meta.maintainers = with lib.maintainers; [ erictapen ];

}
