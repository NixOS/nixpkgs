{ config, lib, ... }:
with lib;
let
  cfg = config.services.oauth2_proxy.nginx;
in
{
  options.services.oauth2_proxy.nginx = {
    proxy = mkOption {
      type = types.str;
      default = config.services.oauth2_proxy.httpAddress;
      defaultText = literalExpression "config.services.oauth2_proxy.httpAddress";
      description = lib.mdDoc ''
        The address of the reverse proxy endpoint for oauth2_proxy
      '';
    };

    domain = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        The domain under which the oauth2_proxy will be accesible and the path of cookies are set to.
        This setting must be set to ensure back-redirects are working properly
        if oauth2-proxy is configured with {option}`services.oauth2_proxy.cookie.domain`
        or multiple {option}`services.oauth2_proxy.nginx.virtualHosts` that are not on the same domain.
      '';
    };

    virtualHosts = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        A list of nginx virtual hosts to put behind the oauth2 proxy
      '';
    };
  };

  config.services.oauth2_proxy = mkIf (cfg.virtualHosts != [] && (hasPrefix "127.0.0.1:" cfg.proxy)) {
    enable = true;
  };

  config.services.nginx = mkIf (cfg.virtualHosts != [] && config.services.oauth2_proxy.enable) (mkMerge ([
    {
      virtualHosts.${cfg.domain}.locations."/oauth2/" = {
        proxyPass = cfg.proxy;
        extraConfig = ''
          proxy_set_header X-Scheme                $scheme;
          proxy_set_header X-Auth-Request-Redirect $scheme://$host$request_uri;
        '';
      };
    }
  ] ++ optional (cfg.virtualHosts != []) {
    recommendedProxySettings = true; # needed because duplicate headers
  } ++ (map (vhost: {
    virtualHosts.${vhost}.locations = {
      "/oauth2/auth" = {
        proxyPass = cfg.proxy;
        extraConfig = ''
          proxy_set_header X-Scheme         $scheme;
          # nginx auth_request includes headers but not body
          proxy_set_header Content-Length   "";
          proxy_pass_request_body           off;
        '';
      };
      "@redirectToAuth2ProxyLogin".return = "307 https://${cfg.domain}/oauth2/start?rd=$scheme://$host$request_uri";
      "/".extraConfig = ''
        auth_request /oauth2/auth;
        error_page 401 = @redirectToAuth2ProxyLogin;

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
    };
  }) cfg.virtualHosts)));
}
