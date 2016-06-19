# NixOS module for oauth2_proxy.

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.oauth2_proxy;

  # Use like:
  #   repeatedArgs (arg: "--arg=${arg}") args
  repeatedArgs = concatMapStringsSep " ";

  # 'toString' doesn't quite do what we want for bools.
  fromBool = x: if x then "true" else "false";

  # oauth2_proxy provides many options that are only relevant if you are using
  # a certain provider. This set maps from provider name to a function that
  # takes the configuration and returns a string that can be inserted into the
  # command-line to launch oauth2_proxy.
  providerSpecificOptions = {
    azure = cfg: ''
      --azure-tenant=${cfg.azure.tenant} \
      --resource=${cfg.azure.resource} \
    '';

    github = cfg: ''
      $(optionalString (!isNull cfg.github.org) "--github-org=${cfg.github.org}") \
      $(optionalString (!isNull cfg.github.team) "--github-org=${cfg.github.team}") \
    '';

    google = cfg: ''
      --google-admin-email=${cfg.google.adminEmail} \
      --google-service-account=${cfg.google.serviceAccountJSON} \
      $(repeatedArgs (group: "--google-group=${group}") cfg.google.groups) \
    '';
  };

  authenticatedEmailsFile = pkgs.writeText "authenticated-emails" cfg.email.addresses;

  getProviderOptions = cfg: provider:
    if providerSpecificOptions ? provider then providerSpecificOptions.provider cfg else "";

  mkCommandLine = cfg: ''
    --provider='${cfg.provider}' \
    ${optionalString (!isNull cfg.email.addresses) "--authenticated-emails-file='${authenticatedEmailsFile}'"} \
    --approval-prompt='${cfg.approvalPrompt}' \
    ${optionalString (cfg.passBasicAuth && !isNull cfg.basicAuthPassword) "--basic-auth-password='${cfg.basicAuthPassword}'"} \
    --client-id='${cfg.clientID}' \
    --client-secret='${cfg.clientSecret}' \
    ${optionalString (!isNull cfg.cookie.domain) "--cookie-domain='${cfg.cookie.domain}'"} \
    --cookie-expire='${cfg.cookie.expire}' \
    --cookie-httponly=${fromBool cfg.cookie.httpOnly} \
    --cookie-name='${cfg.cookie.name}' \
    --cookie-secret='${cfg.cookie.secret}' \
    --cookie-secure=${fromBool cfg.cookie.secure} \
    ${optionalString (!isNull cfg.cookie.refresh) "--cookie-refresh='${cfg.cookie.refresh}'"} \
    ${optionalString (!isNull cfg.customTemplatesDir) "--custom-templates-dir='${cfg.customTemplatesDir}'"} \
    ${repeatedArgs (x: "--email-domain='${x}'") cfg.email.domains} \
    --http-address='${cfg.httpAddress}' \
    ${optionalString (!isNull cfg.htpasswd.file) "--htpasswd-file='${cfg.htpasswd.file}' --display-htpasswd-form=${fromBool cfg.htpasswd.displayForm}"} \
    ${optionalString (!isNull cfg.loginURL) "--login-url='${cfg.loginURL}'"} \
    --pass-access-token=${fromBool cfg.passAccessToken} \
    --pass-basic-auth=${fromBool cfg.passBasicAuth} \
    --pass-host-header=${fromBool cfg.passHostHeader} \
    --proxy-prefix='${cfg.proxyPrefix}' \
    ${optionalString (!isNull cfg.profileURL) "--profile-url='${cfg.profileURL}'"} \
    ${optionalString (!isNull cfg.redeemURL) "--redeem-url='${cfg.redeemURL}'"} \
    ${optionalString (!isNull cfg.redirectURL) "--redirect-url='${cfg.redirectURL}'"} \
    --request-logging=${fromBool cfg.requestLogging} \
    ${optionalString (!isNull cfg.scope) "--scope='${cfg.scope}'"} \
    ${repeatedArgs (x: "--skip-auth-regex='${x}'") cfg.skipAuthRegexes} \
    ${optionalString (!isNull cfg.signatureKey) "--signature-key='${cfg.signatureKey}'"} \
    --upstream='${cfg.upstream}' \
    ${optionalString (!isNull cfg.validateURL) "--validate-url='${cfg.validateURL}'"} \
    ${optionalString cfg.tls.enable "--tls-cert='${cfg.tls.certificate}' --tls-key='${cfg.tls.key}' --https-address='${cfg.tls.httpsAddress}'"} \
  '' + getProviderOptions cfg cfg.provider;
in
{
  options.services.oauth2_proxy = {
    enable = mkEnableOption "oauth2_proxy";

    package = mkOption {
      type = types.package;
      default = pkgs.oauth2_proxy;
      defaultText = "pkgs.oauth2_proxy";
      description = ''
        The package that provides oauth2_proxy.
      '';
    };

    ##############################################
    # PROVIDER configuration
    provider = mkOption {
      type = types.enum [
        "google"
        "github"
        "azure"
        "gitlab"
        "linkedin"
        "myusa"
      ];
      default = "google";
      description = ''
        OAuth provider.
      '';
    };

    approvalPrompt = mkOption {
      type = types.enum ["force" "auto"];
      default = "force";
      description = ''
        OAuth approval_prompt.
      '';
    };

    clientID = mkOption {
      type = types.str;
      description = ''
        The OAuth Client ID.
      '';
      example = "123456.apps.googleusercontent.com";
    };

    clientSecret = mkOption {
      type = types.str;
      description = ''
        The OAuth Client Secret.
      '';
    };

    skipAuthRegexes = mkOption {
     type = types.listOf types.str;
     default = [];
     description = ''
       Skip authentication for requests matching any of these regular
       expressions.
     '';
    };

    # XXX: Not clear whether these two options are mutually exclusive or not.
    email = {
      domains = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Authenticate emails with the specified domains. Use
          <literal>*</literal> to authenticate any email.
        '';
      };

      addresses = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Line-separated email addresses that are allowed to authenticate.
        '';
      };
    };

    loginURL = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
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
      description = ''
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
      description = ''
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
      description = ''
        The OAuth2 redirect URL.
      '';
      example = "https://internalapp.yourcompany.com/oauth2/callback";
    };

    azure = {
      tenant = mkOption {
        type = types.str;
        default = "common";
        description = ''
          Go to a tenant-specific or common (tenant-independent) endpoint.
        '';
      };

      resource = mkOption {
        type = types.str;
        description = ''
          The resource that is protected.
        '';
      };
    };

    google = {
      adminEmail = mkOption {
        type = types.str;
        description = ''
          The Google Admin to impersonate for API calls.

          Only users with access to the Admin APIs can access the Admin SDK
          Directory API, thus the service account needs to impersonate one of
          those users to access the Admin SDK Directory API.

          See <link xlink:href="https://developers.google.com/admin-sdk/directory/v1/guides/delegation#delegate_domain-wide_authority_to_your_service_account" />.
        '';
      };

      groups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Restrict logins to members of these Google groups.
        '';
      };

      serviceAccountJSON = mkOption {
        type = types.path;
        description = ''
          The path to the service account JSON credentials.
        '';
      };
    };

    github = {
      org = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Restrict logins to members of this organisation.
        '';
      };

      team = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Restrict logins to members of this team.
        '';
      };
    };


    ####################################################
    # UPSTREAM Configuration
    upstream = mkOption {
      type = types.commas;
      description = ''
        The http url(s) of the upstream endpoint or <literal>file://</literal>
        paths for static files. Routing is based on the path.
      '';
    };

    passAccessToken = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Pass OAuth access_token to upstream via X-Forwarded-Access-Token header.
      '';
    };

    passBasicAuth = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Pass HTTP Basic Auth, X-Forwarded-User and X-Forwarded-Email information to upstream.
      '';
    };

    basicAuthPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The password to set when passing the HTTP Basic Auth header.
      '';
    };

    passHostHeader = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Pass the request Host Header to upstream.
      '';
    };

    signatureKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        GAP-Signature request signature key.
      '';
      example = "sha1:secret0";
    };

    cookie = {
      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          An optional cookie domain to force cookies to.
        '';
        example = ".yourcompany.com";
      };

      expire = mkOption {
        type = types.str;
        default = "168h0m0s";
        description = ''
          Expire timeframe for cookie.
        '';
      };

      httpOnly = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Set HttpOnly cookie flag.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "_oauth2_proxy";
        description = ''
          The name of the cookie that the oauth_proxy creates.
        '';
      };

      refresh = mkOption {
        # XXX: Unclear what the behavior is when this is not specified.
        type = types.nullOr types.str;
        default = null;
        description = ''
          Refresh the cookie after this duration; 0 to disable.
        '';
        example = "168h0m0s";
      };

      secret = mkOption {
        type = types.str;
        description = ''
          The seed string for secure cookies.
        '';
      };

      secure = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Set secure (HTTPS) cookie flag.
        '';
      };
    };

    ####################################################
    # OAUTH2 PROXY configuration

    httpAddress = mkOption {
      type = types.str;
      default = "127.0.0.1:4180";
      description = ''
        HTTPS listening address.  This module does not expose the port by
        default. If you want this URL to be accessible to other machines, please
        add the port to <literal>networking.firewall.allowedTCPPorts</literal>.
      '';
    };

    htpasswd = {
      file = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Additionally authenticate against a htpasswd file. Entries must be
          created with <literal>htpasswd -s</literal> for SHA encryption.
        '';
      };

      displayForm = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Display username / password login form if an htpasswd file is provided.
        '';
      };
    };

    customTemplatesDir = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to custom HTML templates.
      '';
    };

    proxyPrefix = mkOption {
      type = types.str;
      default = "/oauth2";
      description = ''
        The url root path that this proxy should be nested under.
      '';
    };

    tls = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to serve over TLS.
        '';
      };

      certificate = mkOption {
        type = types.path;
        description = ''
          Path to certificate file.
        '';
      };

      key = mkOption {
        type = types.path;
        description = ''
          Path to private key file.
        '';
      };

      httpsAddress = mkOption {
        type = types.str;
        default = ":443";
        description = ''
          <literal>addr:port</literal> to listen on for HTTPS clients.

          Remember to add <literal>port</literal> to
          <literal>allowedTCPPorts</literal> if you want other machines to be
          able to connect to it.
        '';
      };
    };

    requestLogging = mkOption {
      type = types.bool;
      default = true;
      description = ''
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
      description = ''
        OAuth scope specification.
      '';
    };

    profileURL = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
      	Profile access endpoint.
      '';
    };

  };

  config = mkIf cfg.enable {

    users.extraUsers.oauth2_proxy = {
      description = "OAuth2 Proxy";
    };

    systemd.services.oauth2_proxy = {
      description = "OAuth2 Proxy";
      path = [ cfg.package ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" ];

      serviceConfig = {
        User = "oauth2_proxy";
        Restart = "always";
        ExecStart = "${cfg.package.bin}/bin/oauth2_proxy ${mkCommandLine cfg}";
      };
    };

  };
}
