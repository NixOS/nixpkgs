{ config, lib, ... }:
with lib;
let
  cfg = config.services.oauth2_proxy.nginx;
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "oauth2_proxy" "nginx" "virtualHosts" ]
      "This option has been removed in favor of 'services.oauth2_proxy.nginx.virtualHostLocations' which allows setting the proxy protection at a per-location level.")
  ];

  options.services.oauth2_proxy.nginx = {
    proxy = mkOption {
      type = types.str;
      default = config.services.oauth2_proxy.httpAddress;
      defaultText = literalExpression "config.services.oauth2_proxy.httpAddress";
      description = lib.mdDoc ''
        The address of the reverse proxy endpoint for oauth2_proxy
      '';
    };
    virtualHostLocations = mkOption {
      type = types.attrsOf (types.listOf types.str);
      example = literalExpression ''
        {
          "example.com" = [ "/" "/assets/" ];
        };
      '';
      default = { };
      description = lib.mdDoc "List of locations per virtual host to put behind the oauth2_proxy";
    };
  };
  config = {
    assertions = [{
      assertion = !lib.any (loc: lib.elem loc (flatten (lib.attrValues cfg.virtualHostLocations))) [ "/oauth2/" "/oauth2/auth" ];
      message = "services.oauth2_proxy.nginx.virtualHostLocations: The OAuth2 specific locations cannot be protected.";
    }];

    services.nginx = mkIf (cfg.virtualHostLocations != { }) {
      recommendedProxySettings = true; # needed because duplicate headers
      virtualHosts = lib.mapAttrs
        (vhost: locations: mkMerge [
          {
            locations."/oauth2/" = {
              proxyPass = cfg.proxy;
              extraConfig = ''
                proxy_set_header X-Scheme                $scheme;
                proxy_set_header X-Auth-Request-Redirect $scheme://$host$request_uri;
              '';
            };
            locations."/oauth2/auth" = {
              proxyPass = cfg.proxy;
              extraConfig = ''
                proxy_set_header X-Scheme         $scheme;
                # nginx auth_request includes headers but not body
                proxy_set_header Content-Length   "";
                proxy_pass_request_body           off;
              '';
            };
          }
          {
            locations = genAttrs locations (_: {
              extraConfig = ''
                auth_request /oauth2/auth;
                error_page 401 = /oauth2/sign_in;

                # pass information via X-User and X-Email headers to backend,
                # requires running with --set-xauthrequest flag
                auth_request_set $user   $upstream_http_x_auth_request_user;
                auth_request_set $email  $upstream_http_x_auth_request_email;
                proxy_set_header X-User  $user;
                proxy_set_header X-Email $email;

                # if you enabled --cookie-refresh, this is needed for it to work with auth_request
                auth_request_set $auth_cookie $upstream_http_set_cookie;
                add_header Set-Cookie $auth_cookie;
              '';
            });
          }
        ])
        cfg.virtualHostLocations;
    };
  };
}
