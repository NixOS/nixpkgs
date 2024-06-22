{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    boolToString
    concatStringsSep
    hasAttr
    isBool
    mapAttrs
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  inherit (lib.types)
    attrsOf
    bool
    either
    package
    str
    submodule
    ;

  toStringEnv = value: if isBool value then boolToString value else toString value;

  cfg = config.services.netbird.server.dashboard;
in

{
  options.services.netbird.server.dashboard = {
    enable = mkEnableOption "the static netbird dashboard frontend";

    package = mkPackageOption pkgs "netbird-dashboard" { };

    enableNginx = mkEnableOption "Nginx reverse-proxy to serve the dashboard.";

    domain = mkOption {
      type = str;
      default = "localhost";
      description = "The domain under which the dashboard runs.";
    };

    managementServer = mkOption {
      type = str;
      description = "The address of the management server, used for the API endpoints.";
    };

    settings = mkOption {
      type = submodule { freeformType = attrsOf (either str bool); };

      defaultText = ''
        {
          AUTH_AUDIENCE = "netbird";
          AUTH_CLIENT_ID = "netbird";
          AUTH_SUPPORTED_SCOPES = "openid profile email";
          NETBIRD_TOKEN_SOURCE = "idToken";
          USE_AUTH0 = false;
        }
      '';

      description = ''
        An attribute set that will be used to substitute variables when building the dashboard.
        Any values set here will be templated into the frontend and be public for anyone that can reach your website.
        The exact values sadly aren't documented anywhere.
        A starting point when searching for valid values is this [script](https://github.com/netbirdio/dashboard/blob/main/docker/init_react_envs.sh)
        The only mandatory value is 'AUTH_AUTHORITY' as we cannot set a default value here.
      '';
    };

    finalDrv = mkOption {
      readOnly = true;
      type = package;
      description = ''
        The derivation containing the final templated dashboard.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasAttr "AUTH_AUTHORITY" cfg.settings;
        message = "The setting AUTH_AUTHORITY is required for the dasboard to function.";
      }
    ];

    services.netbird.server.dashboard = {
      settings =
        {
          # Due to how the backend and frontend work this secret will be templated into the backend
          # and then served statically from your website
          # This enables you to login without the normally needed indirection through the backend
          # but this also means anyone that can reach your website can
          # fetch this secret, which is why there is no real need to put it into
          # special options as its public anyway
          # As far as I know leaking this secret is just
          # an information leak as one can fetch some basic app
          # informations from the IDP
          # To actually do something one still needs to have login
          # data and this secret so this being public will not
          # suffice for anything just decreasing security
          AUTH_CLIENT_SECRET = "";

          NETBIRD_MGMT_API_ENDPOINT = cfg.managementServer;
          NETBIRD_MGMT_GRPC_API_ENDPOINT = cfg.managementServer;
        }
        // (mapAttrs (_: mkDefault) {
          # Those values have to be easily overridable
          AUTH_AUDIENCE = "netbird"; # must be set for your devices to be able to log in
          AUTH_CLIENT_ID = "netbird";
          AUTH_SUPPORTED_SCOPES = "openid profile email";
          NETBIRD_TOKEN_SOURCE = "idToken";
          USE_AUTH0 = false;
        });

      # The derivation containing the templated dashboard
      finalDrv =
        pkgs.runCommand "netbird-dashboard"
          {
            nativeBuildInputs = [ pkgs.gettext ];
            env = {
              ENV_STR = concatStringsSep " " [
                "$AUTH_AUDIENCE"
                "$AUTH_AUTHORITY"
                "$AUTH_CLIENT_ID"
                "$AUTH_CLIENT_SECRET"
                "$AUTH_REDIRECT_URI"
                "$AUTH_SILENT_REDIRECT_URI"
                "$AUTH_SUPPORTED_SCOPES"
                "$NETBIRD_DRAG_QUERY_PARAMS"
                "$NETBIRD_GOOGLE_ANALYTICS_ID"
                "$NETBIRD_HOTJAR_TRACK_ID"
                "$NETBIRD_MGMT_API_ENDPOINT"
                "$NETBIRD_MGMT_GRPC_API_ENDPOINT"
                "$NETBIRD_TOKEN_SOURCE"
                "$USE_AUTH0"
              ];
            } // (mapAttrs (_: toStringEnv) cfg.settings);
          }
          ''
            cp -R ${cfg.package} build

            find build -type d -exec chmod 755 {} \;
            OIDC_TRUSTED_DOMAINS="build/OidcTrustedDomains.js"

            envsubst "$ENV_STR" < "$OIDC_TRUSTED_DOMAINS.tmpl" > "$OIDC_TRUSTED_DOMAINS"

            for f in $(grep -R -l AUTH_SUPPORTED_SCOPES build/); do
              mv "$f" "$f.copy"
              envsubst "$ENV_STR" < "$f.copy" > "$f"
              rm "$f.copy"
            done

            cp -R build $out
          '';
    };

    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        locations = {
          "/" = {
            root = cfg.finalDrv;
            tryFiles = "$uri $uri.html $uri/ =404";
          };

          "/404.html".extraConfig = ''
            internal;
          '';
        };

        extraConfig = ''
          error_page 404 /404.html;
        '';
      };
    };
  };
}
