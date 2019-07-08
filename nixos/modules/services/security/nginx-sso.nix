{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx.sso;
  pkg = getBin pkgs.nginx-sso;
  configYml = pkgs.writeText "nginx-sso.yml" (builtins.toJSON cfg.configuration);
in {
  options.services.nginx.sso = {
    enable = mkEnableOption "nginx-sso service";

    configuration = mkOption {
      type = types.attrsOf types.unspecified;
      default = {};
      example = literalExample ''
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
        (<link xlink:href="https://github.com/Luzifer/nginx-sso/wiki/Main-Configuration">documentation</link>)
        as a Nix attribute set.
      '';
    };
  };

  config = mkIf cfg.enable {
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
