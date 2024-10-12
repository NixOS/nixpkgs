{ config, lib, pkgs, ... }:

let
  cfg = config.services.oauth2-proxy;

  # oauth2-proxy provides many options that are only relevant if you are using
  # a certain provider. This set maps from provider name to a function that
  # takes the configuration and returns a string that can be inserted into the
  # command-line to launch oauth2-proxy.
  providerSpecificOptions = {
    azure = cfg: {
      azure-tenant = cfg.azure.tenant;
      resource = cfg.azure.resource;
    };

    github = cfg: { github = {
      inherit (cfg.github) org team;
    }; };

    google = cfg: { google = with cfg.google; lib.optionalAttrs (groups != []) {
      admin-email = adminEmail;
      service-account = serviceAccountJSON;
      group = groups;
    }; };
  };

  authenticatedEmailsFile = pkgs.writeText "authenticated-emails" cfg.email.addresses;

  getProviderOptions = cfg: provider: providerSpecificOptions.${provider} or (_: {}) cfg;

  allConfig = with cfg; {
    inherit (cfg) provider scope upstream;
    approval-prompt = approvalPrompt;
    basic-auth-password = basicAuthPassword;
    client-id = clientID;
    client-secret = clientSecret;
    custom-templates-dir = customTemplatesDir;
    email-domain = email.domains;
    http-address = httpAddress;
    login-url = loginURL;
    pass-access-token = passAccessToken;
    pass-basic-auth = passBasicAuth;
    pass-host-header = passHostHeader;
    reverse-proxy = reverseProxy;
    proxy-prefix = proxyPrefix;
    profile-url = profileURL;
    oidc-issuer-url = oidcIssuerUrl;
    redeem-url = redeemURL;
    redirect-url = redirectURL;
    request-logging = requestLogging;
    skip-auth-regex = skipAuthRegexes;
    signature-key = signatureKey;
    validate-url = validateURL;
    htpasswd-file = htpasswd.file;
    cookie = {
      inherit (cookie) domain secure expire name secret refresh;
      httponly = cookie.httpOnly;
    };
    set-xauthrequest = setXauthrequest;
  } // lib.optionalAttrs (cfg.email.addresses != null) {
    authenticated-emails-file = authenticatedEmailsFile;
  } // lib.optionalAttrs (cfg.passBasicAuth) {
    basic-auth-password = cfg.basicAuthPassword;
  } // lib.optionalAttrs (cfg.htpasswd.file != null) {
    display-htpasswd-file = cfg.htpasswd.displayForm;
  } // lib.optionalAttrs tls.enable {
    tls-cert-file = tls.certificate;
    tls-key-file = tls.key;
    https-address = tls.httpsAddress;
  } // (getProviderOptions cfg cfg.provider) // cfg.extraConfig;

  mapConfig = key: attr:
  lib.optionalString (attr != null && attr != []) (
    if lib.isDerivation attr then mapConfig key (toString attr) else
    if (builtins.typeOf attr) == "set" then lib.concatStringsSep " "
      (lib.mapAttrsToList (name: value: mapConfig (key + "-" + name) value) attr) else
    if (builtins.typeOf attr) == "list" then lib.concatMapStringsSep " " (mapConfig key) attr else
    if (builtins.typeOf attr) == "bool" then "--${key}=${lib.boolToString attr}" else
    if (builtins.typeOf attr) == "string" then "--${key}='${attr}'" else
    "--${key}=${toString attr}");

  configString = lib.concatStringsSep " " (lib.mapAttrsToList mapConfig allConfig);
in
{
  options.services.oauth2-proxy = {
    enable = lib.mkEnableOption "oauth2-proxy";

    package = lib.mkPackageOption pkgs "oauth2-proxy" { };

    ##############################################
    # PROVIDER configuration
    # Taken from: https://github.com/oauth2-proxy/oauth2-proxy/blob/master/providers/providers.go
    provider = lib.mkOption {
      type = lib.types.enum [
        "adfs"
        "azure"
        "bitbucket"
        "digitalocean"
        "facebook"
        "github"
        "gitlab"
        "google"
        "keycloak"
        "keycloak-oidc"
        "linkedin"
        "login.gov"
        "nextcloud"
        "oidc"
      ];
      default = "google";
      description = ''
        OAuth provider.
      '';
    };

    approvalPrompt = lib.mkOption {
      type = lib.types.enum ["force" "auto"];
      default = "force";
      description = ''
        OAuth approval_prompt.
      '';
    };

    clientID = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        The OAuth Client ID.
      '';
      example = "123456.apps.googleusercontent.com";
    };

    oidcIssuerUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The OAuth issuer URL.
      '';
      example = "https://login.microsoftonline.com/{TENANT_ID}/v2.0";
    };

    clientSecret = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = ''
        The OAuth Client Secret.
      '';
    };

    skipAuthRegexes = lib.mkOption {
     type = lib.types.listOf lib.types.str;
     default = [];
     description = ''
       Skip authentication for requests matching any of these regular
       expressions.
     '';
    };

    # XXX: Not clear whether these two options are mutually exclusive or not.
    email = {
      domains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Authenticate emails with the specified domains. Use
          `*` to authenticate any email.
        '';
      };

      addresses = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
        description = ''
          Line-separated email addresses that are allowed to authenticate.
        '';
      };
    };

    loginURL = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Authentication endpoint.

        You only need to set this if you are using a self-hosted provider (e.g.
        Github Enterprise). If you're using a publicly hosted provider
        (e.g github.com), then the default works.
      '';
      example = "https://provider.example.com/oauth/authorize";
    };

    redeemURL = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Token redemption endpoint.

        You only need to set this if you are using a self-hosted provider (e.g.
        Github Enterprise). If you're using a publicly hosted provider
        (e.g github.com), then the default works.
      '';
      example = "https://provider.example.com/oauth/token";
    };

    validateURL = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Access token validation endpoint.

        You only need to set this if you are using a self-hosted provider (e.g.
        Github Enterprise). If you're using a publicly hosted provider
        (e.g github.com), then the default works.
      '';
      example = "https://provider.example.com/user/emails";
    };

    redirectURL = lib.mkOption {
      # XXX: jml suspects this is always necessary, but the command-line
      # doesn't require it so making it optional.
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The OAuth2 redirect URL.
      '';
      example = "https://internalapp.yourcompany.com/oauth2/callback";
    };

    azure = {
      tenant = lib.mkOption {
        type = lib.types.str;
        default = "common";
        description = ''
          Go to a tenant-specific or common (tenant-independent) endpoint.
        '';
      };

      resource = lib.mkOption {
        type = lib.types.str;
        description = ''
          The resource that is protected.
        '';
      };
    };

    google = {
      adminEmail = lib.mkOption {
        type = lib.types.str;
        description = ''
          The Google Admin to impersonate for API calls.

          Only users with access to the Admin APIs can access the Admin SDK
          Directory API, thus the service account needs to impersonate one of
          those users to access the Admin SDK Directory API.

          See <https://developers.google.com/admin-sdk/directory/v1/guides/delegation#delegate_domain-wide_authority_to_your_service_account>.
        '';
      };

      groups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Restrict logins to members of these Google groups.
        '';
      };

      serviceAccountJSON = lib.mkOption {
        type = lib.types.path;
        description = ''
          The path to the service account JSON credentials.
        '';
      };
    };

    github = {
      org = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Restrict logins to members of this organisation.
        '';
      };

      team = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Restrict logins to members of this team.
        '';
      };
    };


    ####################################################
    # UPSTREAM Configuration
    upstream = lib.mkOption {
      type = with lib.types; coercedTo str (x: [x]) (listOf str);
      default = [];
      description = ''
        The http url(s) of the upstream endpoint or `file://`
        paths for static files. Routing is based on the path.
      '';
    };

    passAccessToken = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Pass OAuth access_token to upstream via X-Forwarded-Access-Token header.
      '';
    };

    passBasicAuth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Pass HTTP Basic Auth, X-Forwarded-User and X-Forwarded-Email information to upstream.
      '';
    };

    basicAuthPassword = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The password to set when passing the HTTP Basic Auth header.
      '';
    };

    passHostHeader = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Pass the request Host Header to upstream.
      '';
    };

    signatureKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        GAP-Signature request signature key.
      '';
      example = "sha1:secret0";
    };

    cookie = {
      domain = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Optional cookie domains to force cookies to (ie: `.yourcompany.com`).
          The longest domain matching the request's host will be used (or the shortest
          cookie domain if there is no match).
        '';
        example = ".yourcompany.com";
      };

      expire = lib.mkOption {
        type = lib.types.str;
        default = "168h0m0s";
        description = ''
          Expire timeframe for cookie.
        '';
      };

      httpOnly = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Set HttpOnly cookie flag.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "_oauth2_proxy";
        description = ''
          The name of the cookie that the oauth_proxy creates.
        '';
      };

      refresh = lib.mkOption {
        # XXX: Unclear what the behavior is when this is not specified.
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Refresh the cookie after this duration; 0 to disable.
        '';
        example = "168h0m0s";
      };

      secret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = ''
          The seed string for secure cookies.
        '';
      };

      secure = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Set secure (HTTPS) cookie flag.
        '';
      };
    };

    ####################################################
    # OAUTH2 PROXY configuration

    httpAddress = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:4180";
      description = ''
        HTTPS listening address.  This module does not expose the port by
        default. If you want this URL to be accessible to other machines, please
        add the port to `networking.firewall.allowedTCPPorts`.
      '';
    };

    htpasswd = {
      file = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Additionally authenticate against a htpasswd file. Entries must be
          created with `htpasswd -s` for SHA encryption.
        '';
      };

      displayForm = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Display username / password login form if an htpasswd file is provided.
        '';
      };
    };

    customTemplatesDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to custom HTML templates.
      '';
    };

    reverseProxy = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        In case when running behind a reverse proxy, controls whether headers
        like `X-Real-Ip` are accepted. Usage behind a reverse
        proxy will require this flag to be set to avoid logging the reverse
        proxy IP address.
      '';
    };

    proxyPrefix = lib.mkOption {
      type = lib.types.str;
      default = "/oauth2";
      description = ''
        The url root path that this proxy should be nested under.
      '';
    };

    tls = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to serve over TLS.
        '';
      };

      certificate = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path to certificate file.
        '';
      };

      key = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path to private key file.
        '';
      };

      httpsAddress = lib.mkOption {
        type = lib.types.str;
        default = ":443";
        description = ''
          `addr:port` to listen on for HTTPS clients.

          Remember to add `port` to
          `allowedTCPPorts` if you want other machines to be
          able to connect to it.
        '';
      };
    };

    requestLogging = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Log requests to stdout.
      '';
    };

    ####################################################
    # UNKNOWN

    # XXX: Is this mandatory? Is it part of another group? Is it part of the provider specification?
    scope = lib.mkOption {
      # XXX: jml suspects this is always necessary, but the command-line
      # doesn't require it so making it optional.
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        OAuth scope specification.
      '';
    };

    profileURL = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Profile access endpoint.
      '';
    };

    setXauthrequest = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = false;
      description = ''
        Set X-Auth-Request-User and X-Auth-Request-Email response headers (useful in Nginx auth_request mode). Setting this to 'null' means using the upstream default (false).
      '';
    };

    extraConfig = lib.mkOption {
      default = {};
      type = lib.types.attrsOf lib.types.anything;
      description = ''
        Extra config to pass to oauth2-proxy.
      '';
    };

    keyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        oauth2-proxy allows passing sensitive configuration via environment variables.
        Make a file that contains lines like
        OAUTH2_PROXY_CLIENT_SECRET=asdfasdfasdf.apps.googleuserscontent.com
        and specify the path here.
      '';
      example = "/run/keys/oauth2-proxy";
    };
  };

  imports = [
    (lib.mkRenamedOptionModule [ "services" "oauth2_proxy" ] [ "services" "oauth2-proxy" ])
  ];

  config = lib.mkIf cfg.enable {
    services.oauth2-proxy = lib.mkIf (cfg.keyFile != null) {
      clientID = lib.mkDefault null;
      clientSecret = lib.mkDefault null;
      cookie.secret = lib.mkDefault null;
    };

    users.users.oauth2-proxy = {
      description = "OAuth2 Proxy";
      isSystemUser = true;
      group = "oauth2-proxy";
    };

    users.groups.oauth2-proxy = {};

    systemd.services.oauth2-proxy =
      let needsKeycloak = lib.elem cfg.provider ["keycloak" "keycloak-oidc"]
                          && config.services.keycloak.enable;
      in {
        description = "OAuth2 Proxy";
        path = [ cfg.package ];
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ] ++ lib.optionals needsKeycloak [ "keycloak.service" ];
        after = [ "network-online.target" ] ++ lib.optionals needsKeycloak [ "keycloak.service" ];
        restartTriggers = [ cfg.keyFile ];
        serviceConfig = {
          User = "oauth2-proxy";
          Restart = "always";
          ExecStart = "${lib.getExe cfg.package} ${configString}";
          EnvironmentFile = lib.mkIf (cfg.keyFile != null) cfg.keyFile;
        };
      };
  };
}
