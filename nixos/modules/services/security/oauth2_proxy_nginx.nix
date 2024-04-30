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
      description = ''
        The address of the reverse proxy endpoint for oauth2_proxy
      '';
    };

    domain = mkOption {
      type = types.str;
      description = ''
        The domain under which the oauth2_proxy will be accesible and the path of cookies are set to.
        This setting must be set to ensure back-redirects are working properly
        if oauth2-proxy is configured with {option}`services.oauth2_proxy.cookie.domain`
        or multiple {option}`services.oauth2_proxy.nginx.virtualHosts` that are not on the same domain.
      '';
    };

    virtualHosts = mkOption {
      type = let
        vhostSubmodule = types.submodule {
          options = {
            allowed_groups = mkOption {
              type = types.nullOr (types.listOf types.str);
              description = "List of groups to allow access to this vhost, or null to allow all.";
              default = null;
            };
            allowed_emails = mkOption {
              type = types.nullOr (types.listOf types.str);
              description = "List of emails to allow access to this vhost, or null to allow all.";
              default = null;
            };
            allowed_email_domains = mkOption {
              type = types.nullOr (types.listOf types.str);
              description = "List of email domains to allow access to this vhost, or null to allow all.";
              default = null;
            };
          };
        };
        oldType = types.listOf types.str;
        convertFunc = x:
          lib.warn "services.oauth2_proxy.nginx.virtualHosts should be an attrset, found ${lib.generators.toPretty {} x}"
          lib.genAttrs x (_: {});
        newType = types.attrsOf vhostSubmodule;
      in types.coercedTo oldType convertFunc newType;
      default = {};
      example = {
        "protected.foo.com" = {
          allowed_groups = ["admins"];
          allowed_emails = ["boss@foo.com"];
        };
      };
      description = ''
        Nginx virtual hosts to put behind the oauth2 proxy.
        You can exclude specific locations by setting `auth_request off;` in the locations extraConfig setting.
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
  } ++ (lib.mapAttrsToList (vhost: conf: {
    virtualHosts.${vhost} = {
      locations = {
        "/oauth2/auth" = let
          maybeQueryArg = name: value:
            if value == null then null
            else "${name}=${lib.concatStringsSep "," (builtins.map lib.escapeURL value)}";
          allArgs = lib.mapAttrsToList maybeQueryArg conf;
          cleanArgs = builtins.filter (x: x != null) allArgs;
          cleanArgsStr = lib.concatStringsSep "&" cleanArgs;
        in {
          # nginx doesn't support passing query string arguments to auth_request,
          # so pass them here instead
          proxyPass = "${cfg.proxy}/oauth2/auth?${cleanArgsStr}";
          extraConfig = ''
            auth_request off;
            proxy_set_header X-Scheme         $scheme;
            # nginx auth_request includes headers but not body
            proxy_set_header Content-Length   "";
            proxy_pass_request_body           off;
          '';
        };
        "@redirectToAuth2ProxyLogin" = {
          return = "307 https://${cfg.domain}/oauth2/start?rd=$scheme://$host$request_uri";
          extraConfig = ''
            auth_request off;
          '';
        };
      };

      extraConfig = ''
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
