{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx.tailscaleAuth;
in
{
  options.services.nginx.tailscaleAuth = {
    enable = mkEnableOption (lib.mdDoc "Enable tailscale.nginx-auth, to authenticate nginx users via tailscale.");

    package = lib.mkPackageOptionMD pkgs "tailscale-nginx-auth" {};

    user = mkOption {
      type = types.str;
      default = "tailscale-nginx-auth";
      description = lib.mdDoc "User which runs tailscale-nginx-auth";
    };

    group = mkOption {
      type = types.str;
      default = "tailscale-nginx-auth";
      description = lib.mdDoc "Group which runs tailscale-nginx-auth";
    };

    expectedTailnet = mkOption {
      default = "";
      type = types.nullOr types.str;
      example = "tailnet012345.ts.net";
      description = lib.mdDoc ''
        If you want to prevent node sharing from allowing users to access services
        across tailnets, declare your expected tailnets domain here.
      '';
    };

    socketPath = mkOption {
      default = "/run/tailscale-nginx-auth/tailscale-nginx-auth.sock";
      type = types.path;
      description = lib.mdDoc ''
        Path of the socket listening to nginx authorization requests.
      '';
    };

    virtualHosts = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        A list of nginx virtual hosts to put behind tailscale.nginx-auth
      '';
    };
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    services.nginx.enable = true;

    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
    };
    users.groups.${cfg.group} = { };
    users.users.${config.services.nginx.user}.extraGroups = [ cfg.group ];
    systemd.sockets.tailscale-nginx-auth = {
      description = "Tailscale NGINX Authentication socket";
      partOf = [ "tailscale-nginx-auth.service" ];
      wantedBy = [ "sockets.target" ];
      listenStreams = [ cfg.socketPath ];
      socketConfig = {
        SocketMode = "0660";
        SocketUser = cfg.user;
        SocketGroup = cfg.group;
      };
    };


    systemd.services.tailscale-nginx-auth = {
      description = "Tailscale NGINX Authentication service";
      after = [ "nginx.service" ];
      wants = [ "nginx.service" ];
      requires = [ "tailscale-nginx-auth.socket" ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        RuntimeDirectory = "tailscale-nginx-auth";
        User = cfg.user;
        Group = cfg.group;

        BindPaths = [ "/run/tailscale/tailscaled.sock" ];

        CapabilityBoundingSet = "";
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [ "AF_UNIX" ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation" "~@debug" "~@keyring" "~@memlock" "~@obsolete" "~@privileged" "~@setuid"
        ];
      };
    };

    services.nginx.virtualHosts = genAttrs
      cfg.virtualHosts
      (vhost: {
        locations."/auth" = {
          extraConfig = ''
            internal;

            proxy_pass http://unix:${cfg.socketPath};
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

          ${lib.optionalString (cfg.expectedTailnet != "") ''proxy_set_header Expected-Tailnet "${cfg.expectedTailnet}";''}
        '';
      });
  };

  meta.maintainers = with maintainers; [ phaer ];

}
