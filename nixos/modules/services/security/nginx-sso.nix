{ config, lib, pkgs, ... }:
let
  cfg = config.services.nginx.sso;
  pkg = lib.getBin cfg.package;
  configYml = pkgs.writeText "nginx-sso.yml" (builtins.toJSON cfg.configuration);
in {
  options.services.nginx.sso = {
    enable = lib.mkEnableOption "nginx-sso service";

    package = lib.mkPackageOption pkgs "nginx-sso" { };

    configuration = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = {};
      example = lib.literalExpression ''
        {
          listen = { addr = "127.0.0.1"; port = 8080; };

          providers.token.tokens = {
            myuser = "MyToken";
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
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nginx-sso = {
      description = "Nginx SSO Backend";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkg}/bin/nginx-sso \
            --config ${configYml} \
            --frontend-dir ${pkg}/share/frontend
        '';
        Restart = "always";
        DynamicUser = true;
      };
    };
  };
}
