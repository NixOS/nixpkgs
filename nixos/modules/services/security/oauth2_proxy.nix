# NixOS module for oauth2_proxy.

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.oauth2_proxy;

  # oauth2_proxy provides many options that are only relevant if you are using
  # a certain provider. This set maps from provider name to a function that
  # takes the configuration and returns a string that can be inserted into the
  # command-line to launch oauth2_proxy.
  providerSpecificOptions = {
    azure = cfg: {
      azure-tenant = cfg.azure.tenant;
      resource = cfg.azure.resource;
    };

    github = cfg: { github = {
      inherit (cfg.github) org team;
    }; };

    google = cfg: { google = with cfg.google; optionalAttrs (groups != []) {
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
  optionalString (attr != null && attr != []) (
    if isDerivation attr then mapConfig key (toString attr) else
    if (builtins.typeOf attr) == "set" then concatStringsSep " "
      (mapAttrsToList (name: value: mapConfig (key + "-" + name) value) attr) else
    if (builtins.typeOf attr) == "list" then concatMapStringsSep " " (mapConfig key) attr else
    if (builtins.typeOf attr) == "bool" then "--${key}=${boolToString attr}" else
    if (builtins.typeOf attr) == "string" then "--${key}='${attr}'" else
    "--${key}=${toString attr}");

  configString = concatStringsSep " " (mapAttrsToList mapConfig allConfig);
in
{
  options.services.oauth2_proxy = {
    enable = mkEnableOption (lib.mdDoc "oauth2_proxy");

    package = mkPackageOption pkgs "oauth2-proxy" { };

    ##############################################
    # PROVIDER configuration
    # Taken from: https://github.com/oauth2-proxy/oauth2-proxy/blob/master/providers/providers.go
    provider = mkOption {
      type = types.enum [
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
      description = lib.mdDoc ''
        OAuth provider.
      '';
    };

    approvalPrompt = mkOption {
      type = types.enum ["force" "auto"];
      default = "force";
      description = lib.mdDoc ''
        OAuth approval_prompt.
      '';
    };

    clientID = mkOption {
      type = types.nullOr types.str;
      description = lib.mdDoc ''
        The OAuth Client ID.
      '';
      example = "123456.apps.googleusercontent.com";
    };

    clientSecret = mkOption {
      type = types.nullOr types.str;
      description = lib.mdDoc ''
        The OAuth Client Secret.
      '';
    };

    skipAuthRegexes = mkOption {
     type = types.listOf types.str;
     default = [];
     description = lib.mdDoc ''
       Skip authentication for requests matching any of these regular
       expressions.
     '';
    };

    # XXX: Not clear whether these two options are mutually exclusive or not.
    email = {
      domains = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Authenticate emails with the specified domains. Use
          `*` to authenticate any email.
        '';
      };

      addresses = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = lib.mdDoc ''
          Line-separated email addresses that are allowed to authenticate.
        '';
      };
    };

    loginURL = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Authentication endpoint.

        You only need to set this if you are using a self-hosted provider (e.g.
        Github Enterprise). If you're using a publicly hosted provider
        (e.g github.com), then the default works.
      '';
      example = "https://provider.example.com/oauth/authorize";
    };

    redeemURL = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Token redemption endpoint.

        You only need to set this if you are using a self-hosted provider (e.g.
        Github Enterprise). If you're using a publicly hosted provider
        (e.g github.com), then the default works.
      '';
      example = "https://provider.example.com/oauth/token";
    };

    validateURL = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Access token validation endpoint.

        You only need to set this if you are using a self-hosted provider (e.g.
        Github Enterprise). If you're using a publicly hosted provider
        (e.g github.com), then the default works.
      '';
      example = "https://provider.example.com/user/emails";
    };

    redirectURL = mkOption {
      # XXX: jml suspects this is always necessary, but the command-line
      # doesn't require it so making it optional.
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        The OAuth2 redirect URL.
      '';
      example = "https://internalapp.yourcompany.com/oauth2/callback";
    };

    azure = {
      tenant = mkOption {
        type = types.str;
        default = "common";
        description = lib.mdDoc ''
          Go to a tenant-specific or common (tenant-independent) endpoint.
        '';
      };

      resource = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The resource that is protected.
        '';
      };
    };

    google = {
      adminEmail = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The Google Admin to impersonate for API calls.

          Only users with access to the Admin APIs can access the Admin SDK
          Directory API, thus the service account needs to impersonate one of
          those users to access the Admin SDK Directory API.

          See <https://developers.google.com/admin-sdk/directory/v1/guides/delegation#delegate_domain-wide_authority_to_your_service_account>.
        '';
      };

      groups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc ''
          Restrict logins to members of these Google groups.
        '';
      };

      serviceAccountJSON = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          The path to the service account JSON credentials.
        '';
      };
    };

    github = {
      org = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Restrict logins to members of this organisation.
        '';
      };

      team = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Restrict logins to members of this team.
        '';
      };
    };


    ####################################################
    # UPSTREAM Configuration
    upstream = mkOption {
      type = with types; coercedTo str (x: [x]) (listOf str);
      default = [];
      description = lib.mdDoc ''
        The http url(s) of the upstream endpoint or `file://`
        paths for static files. Routing is based on the path.
      '';
    };

    passAccessToken = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Pass OAuth access_token to upstream via X-Forwarded-Access-Token header.
      '';
    };

    passBasicAuth = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Pass HTTP Basic Auth, X-Forwarded-User and X-Forwarded-Email information to upstream.
      '';
    };

    basicAuthPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        The password to set when passing the HTTP Basic Auth header.
      '';
    };

    passHostHeader = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Pass the request Host Header to upstream.
      '';
    };

    signatureKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        GAP-Signature request signature key.
      '';
      example = "sha1:secret0";
    };

    cookie = {
      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Optional cookie domains to force cookies to (ie: `.yourcompany.com`).
          The longest domain matching the request's host will be used (or the shortest
          cookie domain if there is no match).
        '';
        example = ".yourcompany.com";
      };

      expire = mkOption {
        type = types.str;
        default = "168h0m0s";
        description = lib.mdDoc ''
          Expire timeframe for cookie.
        '';
      };

      httpOnly = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Set HttpOnly cookie flag.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "_oauth2_proxy";
        description = lib.mdDoc ''
          The name of the cookie that the oauth_proxy creates.
        '';
      };

      refresh = mkOption {
        # XXX: Unclear what the behavior is when this is not specified.
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Refresh the cookie after this duration; 0 to disable.
        '';
        example = "168h0m0s";
      };

      secret = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          The seed string for secure cookies.
        '';
      };

      secure = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Set secure (HTTPS) cookie flag.
        '';
      };
    };

    ####################################################
    # OAUTH2 PROXY configuration

    httpAddress = mkOption {
      type = types.str;
      default = "http://127.0.0.1:4180";
      description = lib.mdDoc ''
        HTTPS listening address.  This module does not expose the port by
        default. If you want this URL to be accessible to other machines, please
        add the port to `networking.firewall.allowedTCPPorts`.
      '';
    };

    htpasswd = {
      file = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          Additionally authenticate against a htpasswd file. Entries must be
          created with `htpasswd -s` for SHA encryption.
        '';
      };

      displayForm = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Display username / password login form if an htpasswd file is provided.
        '';
      };
    };

    customTemplatesDir = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Path to custom HTML templates.
      '';
    };

    reverseProxy = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        In case when running behind a reverse proxy, controls whether headers
        like `X-Real-Ip` are accepted. Usage behind a reverse
        proxy will require this flag to be set to avoid logging the reverse
        proxy IP address.
      '';
    };

    proxyPrefix = mkOption {
      type = types.str;
      default = "/oauth2";
      description = lib.mdDoc ''
        The url root path that this proxy should be nested under.
      '';
    };

    tls = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to serve over TLS.
        '';
      };

      certificate = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          Path to certificate file.
        '';
      };

      key = mkOption {
        type = types.path;
        description = lib.mdDoc ''
          Path to private key file.
        '';
      };

      httpsAddress = mkOption {
        type = types.str;
        default = ":443";
        description = lib.mdDoc ''
          `addr:port` to listen on for HTTPS clients.

          Remember to add `port` to
          `allowedTCPPorts` if you want other machines to be
          able to connect to it.
        '';
      };
    };

    requestLogging = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Log requests to stdout.
      '';
    };

    ####################################################
    # UNKNOWN

    # XXX: Is this mandatory? Is it part of another group? Is it part of the provider specification?
    scope = mkOption {
      # XXX: jml suspects this is always necessary, but the command-line
      # doesn't require it so making it optional.
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        OAuth scope specification.
      '';
    };

    profileURL = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Profile access endpoint.
      '';
    };

    setXauthrequest = mkOption {
      type = types.nullOr types.bool;
      default = false;
      description = lib.mdDoc ''
        Set X-Auth-Request-User and X-Auth-Request-Email response headers (useful in Nginx auth_request mode). Setting this to 'null' means using the upstream default (false).
      '';
    };

    extraConfig = mkOption {
      default = {};
      type = types.attrsOf types.anything;
      description = lib.mdDoc ''
        Extra config to pass to oauth2-proxy.
      '';
    };

    keyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        oauth2-proxy allows passing sensitive configuration via environment variables.
        Make a file that contains lines like
        OAUTH2_PROXY_CLIENT_SECRET=asdfasdfasdf.apps.googleuserscontent.com
        and specify the path here.
      '';
      example = "/run/keys/oauth2_proxy";
    };

  };

  config = mkIf cfg.enable {

    services.oauth2_proxy = mkIf (cfg.keyFile != null) {
      clientID = mkDefault null;
      clientSecret = mkDefault null;
      cookie.secret = mkDefault null;
    };

    users.users.oauth2_proxy = {
      description = "OAuth2 Proxy";
      isSystemUser = true;
      group = "oauth2_proxy";
    };

    users.groups.oauth2_proxy = {};

    systemd.services.oauth2_proxy = {
      description = "OAuth2 Proxy";
      path = [ cfg.package ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        User = "oauth2_proxy";
        Restart = "always";
        ExecStart = "${cfg.package}/bin/oauth2-proxy ${configString}";
        EnvironmentFile = mkIf (cfg.keyFile != null) cfg.keyFile;
      };
    };

  };
}
