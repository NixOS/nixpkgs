{ config, lib, ... }:

let
  inherit (lib)
    genAttrs
    maintainers
    mkAliasOptionModule
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.services.nginx.tailscaleAuth;
  cfgAuth = config.services.tailscaleAuth;
in
{
  imports = [
    (mkAliasOptionModule
      [
        "services"
        "nginx"
        "tailscaleAuth"
        "package"
      ]
      [
        "services"
        "tailscaleAuth"
        "package"
      ]
    )
    (mkAliasOptionModule
      [
        "services"
        "nginx"
        "tailscaleAuth"
        "user"
      ]
      [
        "services"
        "tailscaleAuth"
        "user"
      ]
    )
    (mkAliasOptionModule
      [
        "services"
        "nginx"
        "tailscaleAuth"
        "group"
      ]
      [
        "services"
        "tailscaleAuth"
        "group"
      ]
    )
    (mkAliasOptionModule
      [
        "services"
        "nginx"
        "tailscaleAuth"
        "socketPath"
      ]
      [
        "services"
        "tailscaleAuth"
        "socketPath"
      ]
    )
  ];

  options.services.nginx.tailscaleAuth = {
    enable = mkEnableOption "tailscale.nginx-auth, to authenticate nginx users via tailscale";

    expectedTailnet = mkOption {
      default = "";
      type = types.nullOr types.str;
      example = "tailnet012345.ts.net";
      description = ''
        If you want to prevent node sharing from allowing users to access services
        across tailnets, declare your expected tailnets domain here.
      '';
    };

    virtualHosts = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        A list of nginx virtual hosts to put behind tailscale.nginx-auth
      '';
    };
  };

  config = mkIf cfg.enable {
    services.tailscaleAuth.enable = true;
    services.nginx.enable = true;

    users.users.${config.services.nginx.user}.extraGroups = [ cfgAuth.group ];

    systemd.services.tailscale-nginx-auth = {
      after = [ "nginx.service" ];
      wants = [ "nginx.service" ];
    };

    services.nginx.virtualHosts = genAttrs cfg.virtualHosts (vhost: {
      locations."/auth" = {
        extraConfig = ''
          internal;

          proxy_pass http://unix:${cfgAuth.socketPath};
          proxy_pass_request_body off;

          # Upstream uses $http_host here, but we are using gixy to check nginx configurations
          # gixy wants us to use $host: https://github.com/yandex/gixy/blob/master/docs/en/plugins/hostspoofing.md
          proxy_set_header Host $host;
          proxy_set_header Remote-Addr $remote_addr;
          proxy_set_header Remote-Port $remote_port;
          proxy_set_header Original-URI $request_uri;
          proxy_set_header X-Scheme                $scheme;
          proxy_set_header X-Auth-Request-Redirect $scheme://$host$request_uri;
        '';
      };
      locations."/".extraConfig = ''
        auth_request /auth;
        auth_request_set $auth_user $upstream_http_tailscale_user;
        auth_request_set $auth_name $upstream_http_tailscale_name;
        auth_request_set $auth_login $upstream_http_tailscale_login;
        auth_request_set $auth_tailnet $upstream_http_tailscale_tailnet;
        auth_request_set $auth_profile_picture $upstream_http_tailscale_profile_picture;

        proxy_set_header X-Webauth-User "$auth_user";
        proxy_set_header X-Webauth-Name "$auth_name";
        proxy_set_header X-Webauth-Login "$auth_login";
        proxy_set_header X-Webauth-Tailnet "$auth_tailnet";
        proxy_set_header X-Webauth-Profile-Picture "$auth_profile_picture";

        ${lib.optionalString (
          cfg.expectedTailnet != ""
        ) ''proxy_set_header Expected-Tailnet "${cfg.expectedTailnet}";''}
      '';
    });
  };

  meta.maintainers = with maintainers; [ phaer ];

}
