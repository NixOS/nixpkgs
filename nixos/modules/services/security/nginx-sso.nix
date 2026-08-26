{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.nginx.sso;
  format = pkgs.formats.yaml { };
  configPath = "/run/nginx-sso/config.yaml";
  secretsReplacement = utils.genJqSecretsReplacement {
    loadCredential = true;
  } cfg.configuration configPath;
in
{
  options.services.nginx.sso = {
    enable = lib.mkEnableOption "nginx-sso service";

    package = lib.mkPackageOption pkgs "nginx-sso" { };

    configuration = lib.mkOption {
      type = format.type;
      default = { };
      example = lib.literalExpression ''
        {
          listen = { addr = "127.0.0.1"; port = 8080; };

          providers.token.tokens = {
            myuser = {
              _secret = "/path/to/secret/token.txt"; # File content should be the secret token
            };
          };

          acl = {
            rule_sets = [
              {
                rules = [ { field = "x-application"; equals = "MyApp"; } ];
                allow = [ "myuser" ];
              }
            ];
          };
        }
      '';
      description = ''
        nginx-sso configuration
        ([documentation](https://github.com/Luzifer/nginx-sso/wiki/Main-Configuration))
        as a Nix attribute set.

        Options containing secret data should be set to an attribute set
        with the singleton attribute `_secret` - a string value set to the path
        to the file containing the secret value which should be used in the
        configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nginx-sso = {
      description = "Nginx SSO Backend";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = secretsReplacement.script;
      serviceConfig = {
        StateDirectory = "nginx-sso";
        WorkingDirectory = "/var/lib/nginx-sso";
        RuntimeDirectory = "nginx-sso";
        RuntimeDirectoryMode = "0700"; # Contains secrets
        ExecStart = ''
          ${lib.getExe cfg.package} \
            --config ${configPath} \
            --frontend-dir ${lib.getBin cfg.package}/share/frontend
        '';
        LoadCredential = secretsReplacement.credentials;
        Restart = "always";
        DynamicUser = true;
      };
    };
  };
}
