{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.atlantis;
in
{
  options.services.atlantis = {
    enable = lib.mkEnableOption "Atlantis service";

    package = lib.mkPackageOption pkgs "atlantis" { };

    serverArgs = lib.mkOption {
      description = ''
        Arguments passed to Atlantis server.

        See the docs for details:
        <https://www.runatlantis.io/docs/server-configuration.html>
      '';
      example = {
        atlantis-url = "https://atlantis.example.com";
        gh-user = "github_user";
        gh-token = "github_token";
        gh-webhook-secret = "webhook_secret";
        repo-allowlist = "github.com/yourorg/yourrepo";
        default-tf-version = "1.12.2";
      };
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/atlantis";
      description = ''
        Environment file to inject e.g. secrets into the configuration.
      '';
    };

    dataDir = lib.mkOption {
      description = "Data directory for Atlantis.";
      default = "/var/lib/atlantis";
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd = {
      services.atlantis = {
        description = "Atlantis Terraform Pull Request Automation Service";
        after = [ "network.target" ];
        wants = [ "network.target" ];
        restartTriggers = [ cfg.environmentFile ];
        serviceConfig = {
          StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/atlantis") (baseNameOf cfg.dataDir);
          User = "atlantis";
          Group = "atlantis";
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          ExecStart = ''
            ${lib.getExe cfg.package} server ${lib.cli.toGNUCommandLineShell { } cfg.serverArgs}
          '';
          Restart = "on-failure";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };

    users.users.atlantis = {
      description = "Atlantis user";
      home = cfg.dataDir;
      createHome = true;
      group = "atlantis";
      isSystemUser = true;
    };
    users.groups.atlantis = { };
  };
}
