{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.atlantis;
  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.atlantis = {
    enable = lib.mkEnableOption "Atlantis service";

    package = lib.mkPackageOption pkgs "atlantis" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "atlantis";
      description = "User account under which Atlantis runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "atlantis";
      description = "Group account under which Atlantis runs.";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.opentofu pkgs.nix ]";
      description = ''
        Extra packages to add to the Atlantis service PATH.
      '';
    };

    settings = lib.mkOption {
      description = ''
        Settings written to the Atlantis server YAML configuration file.
        The generated file is stored in the Nix store and readable by other
        users. Keep secrets out of this option. Use
        {option}`services.atlantis.environmentFile` to provide secret values
        as environment variables, or {option}`services.atlantis.credentials`
        to provide secret files whose paths are exposed as environment
        variables.

        See the docs for details:
        <https://www.runatlantis.io/docs/server-configuration.html>
      '';
      example = lib.literalExpression ''
        {
          atlantis-url = "https://atlantis.example.com";
          gh-user = "github_user";
          repo-allowlist = "github.com/yourorg/yourrepo";
          default-tf-version = "1.12.2";
        }
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options.port = lib.mkOption {
          type = lib.types.port;
          default = 4141;
          description = "Port on which Atlantis listens.";
        };
      };
      default = { };
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--verbose" ];
      description = ''
        Extra command-line arguments to pass to `atlantis server`.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall port for Atlantis.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/atlantis";
      description = ''
        Environment file containing secrets.
        Restart Atlantis to load changes to the file.
      '';
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Environment variables to pass to Atlantis and its Terraform subprocesses.
      '';
      example = lib.literalExpression ''
        {
          ATLANTIS_GH_USER = "atlantis-bot";
        }
      '';
    };

    credentials = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      description = ''
        Secret files to pass to Atlantis and its Terraform subprocesses. Each
        attribute name is exported with the systemd credential path as its
        value. For example, a `TF_VAR_` attribute lets Terraform consume the
        file with `file(var.<name>)`. Values are loaded with systemd
        `LoadCredential`. Restart Atlantis to load changes to the files.
      '';
      example = lib.literalExpression ''
        {
          TF_VAR_example_secret_file = "/run/secrets/example";
        }
      '';
    };

    dataDir = lib.mkOption {
      description = "Data directory for Atlantis.";
      default = "/var/lib/atlantis";
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.intersectAttrs cfg.credentials cfg.environment == { };
        message = "services.atlantis.credentials and services.atlantis.environment must not define the same environment variable names.";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.settings.port;

    systemd = {
      services.atlantis = {
        description = "Atlantis Terraform Pull Request Automation Service";
        after = [ "network.target" ];
        wants = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [
          pkgs.git
          pkgs.bash
          pkgs.conftest
        ]
        ++ cfg.extraPackages;
        environment = (lib.mapAttrs (name: _: "%d/${name}") cfg.credentials) // cfg.environment;
        serviceConfig = {
          StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/atlantis") "atlantis";
          StateDirectoryMode = "0700";
          WorkingDirectory = cfg.dataDir;
          User = cfg.user;
          Group = cfg.group;
          PrivateTmp = true;
          RestartSec = "5s";
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          LoadCredential = lib.mapAttrsToList (name: path: "${name}:${path}") cfg.credentials;
          ExecStart = utils.escapeSystemdExecArgs (
            [
              (lib.getExe cfg.package)
              "server"
              "--config"
              (settingsFormat.generate "atlantis-config.yaml" cfg.settings)
            ]
            ++ cfg.extraArgs
          );
          Restart = "on-failure";
        };
      };
    };

    users.users = lib.optionalAttrs (cfg.user == "atlantis") {
      atlantis = {
        description = "Atlantis user";
        home = cfg.dataDir;
        createHome = true;
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = lib.optionalAttrs (cfg.group == "atlantis") {
      atlantis = { };
    };
  };
}
