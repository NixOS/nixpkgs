{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.cockpit;
  inherit (lib)
    types
    mkEnableOption
    mkOption
    mkIf
    mkPackageOption
    ;
  settingsFormat = pkgs.formats.ini { };

  pathPkgs = [ cfg.package ] ++ cfg.plugins;

  resourcesEnv = pkgs.buildEnv {
    name = "cockpit-plugins";
    paths = pathPkgs;
    pathsToLink = [ "/share/cockpit" ];
  };

  depsEnv = pkgs.buildEnv {
    name = "cockpit-plugins-env";
    paths = lib.concatMap (p: p.passthru.cockpitPath or [ ]) pathPkgs;
    pathsToLink = [
      "/bin"
      "/share"
      "/lib"
    ];
  };

  share = pkgs.buildEnv {
    name = "cockpit-share";
    paths = [
      resourcesEnv
      depsEnv
    ];
    pathsToLink = [ "/share" ];
  };
in
{
  options = {
    services.cockpit = {
      enable = mkEnableOption "Cockpit";

      package = mkPackageOption pkgs "Cockpit" {
        default = [ "cockpit" ];
      };

      plugins = lib.mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          List of cockpit plugins.

          This add the passthru.cockpitPath of the packages to the systemd cockpit service.
        '';
        example = lib.literalExpression ''
          [
            pkgs.cockpit-zfs
          ]
        '';
      };

      allowed-origins = lib.mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          List of allowed origins.

          Maps to the WebService.Origins setting and allows merging from multiple modules.
        '';
      };

      settings = lib.mkOption {
        type = settingsFormat.type;

        default = { };

        description = ''
          Settings for cockpit that will be saved in /etc/cockpit/cockpit.conf.

          See the [documentation](https://cockpit-project.org/guide/latest/cockpit.conf.5.html), that is also available with `man cockpit.conf.5` for details.
        '';
      };

      showBanner = mkOption {
        description = "Whether to add the Cockpit banner to the issue and motd files.";
        type = types.bool;
        default = true;
        example = false;
      };

      port = mkOption {
        description = "Port where cockpit will listen.";
        type = types.port;
        default = 9090;
      };

      openFirewall = mkOption {
        description = "Open port for cockpit.";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {

    environment.etc = {
      # generate cockpit settings
      "cockpit/cockpit.conf".source = settingsFormat.generate "cockpit.conf" cfg.settings;

      # Add "Web console: ..." line to issue and MOTD
      "issue.d/cockpit.issue" = {
        enable = cfg.showBanner;
        source = "/run/cockpit/issue";
      };
      "motd.d/cockpit" = {
        enable = cfg.showBanner;
        source = "/run/cockpit/issue";
      };

      # Add plugins in discoverable folder
      "cockpit/share".source = "${share}/share";

      # Add plugins dependencies
      "cockpit/bin".source = "${depsEnv}/bin";
      "cockpit/lib".source = "${depsEnv}/lib";
    };

    security.pam.services.cockpit = {
      startSession = true;
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.packages = [ cfg.package ];

    systemd.sockets.cockpit = {
      wantedBy = [ "multi-user.target" ];
      listenStreams = [
        "" # workaround so it doesn't listen on both ports caused by the runtime merging
        (toString cfg.port)
      ];
    };

    # Enable connecting to remote hosts from the login page
    systemd.services = mkIf (cfg.settings ? LoginTo -> cfg.settings.LoginTo) {
      "cockpit-wsinstance-http".path = [
        config.programs.ssh.package
        cfg.package
      ];
      "cockpit-wsinstance-https@".path = [
        config.programs.ssh.package
        cfg.package
      ];
    };

    systemd.tmpfiles.rules = [
      # From $out/lib/tmpfiles.d/cockpit-tmpfiles.conf
      "C /run/cockpit/inactive.motd 0640 root root - ${cfg.package}/share/cockpit/motd/inactive.motd"
      "f /run/cockpit/active.motd   0640 root root -"
      "L+ /run/cockpit/motd - - - - inactive.motd"
      "d /etc/cockpit/ws-certs.d 0600 root root 0"
    ];

    services.cockpit.allowed-origins = [
      "https://localhost:${toString config.services.cockpit.port}"
    ];

    services.cockpit.settings.WebService.Origins =
      builtins.concatStringsSep " " config.services.cockpit.allowed-origins;
  };

  meta.maintainers = pkgs.cockpit.meta.maintainers;
}
