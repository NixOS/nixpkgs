{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types;

  cfg = config.services.frigate;

  format = pkgs.formats.yaml { };

  filteredConfig = lib.converge (lib.filterAttrsRecursive (_: v: ! lib.elem v [ null ])) cfg.settings;

  cameraFormat = with types; submodule {
    freeformType = format.type;
    options = {
      ffmpeg = {
        inputs = mkOption {
          description = ''
            List of inputs for this camera.
          '';
          type = listOf (submodule {
            freeformType = format.type;
            options = {
              path = mkOption {
                type = str;
                example = "rtsp://192.0.2.1:554/rtsp";
                description = ''
                  Stream URL
                '';
              };
              roles = mkOption {
                type = listOf (enum [ "audio" "detect" "record" ]);
                example = [ "detect" "record" ];
                description = ''
                  List of roles for this stream
                '';
              };
            };
          });
        };
      };
    };
  };

  # auth_request.conf
  nginxAuthRequest = ''
    # Send a subrequest to verify if the user is authenticated and has permission to access the resource.
    auth_request /auth;

    # Save the upstream metadata response headers from Authelia to variables.
    auth_request_set $user $upstream_http_remote_user;
    auth_request_set $groups $upstream_http_remote_groups;
    auth_request_set $name $upstream_http_remote_name;
    auth_request_set $email $upstream_http_remote_email;

    # Inject the metadata response headers from the variables into the request made to the backend.
    proxy_set_header Remote-User $user;
    proxy_set_header Remote-Groups $groups;
    proxy_set_header Remote-Email $email;
    proxy_set_header Remote-Name $name;

    # Refresh the cookie as needed
    auth_request_set $auth_cookie $upstream_http_set_cookie;
    add_header Set-Cookie $auth_cookie;

    # Pass the location header back up if it exists
    auth_request_set $redirection_url $upstream_http_location;
    add_header Location $redirection_url;
  '';

  nginxProxySettings = ''
    # Basic Proxy Configuration
    client_body_buffer_size 128k;
    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; ## Timeout if the real server is dead.
    proxy_redirect  http://  $scheme://;
    proxy_cache_bypass $cookie_session;
    proxy_no_cache $cookie_session;
    proxy_buffers 64 256k;

    # Advanced Proxy Configuration
    send_timeout 5m;
    proxy_read_timeout 360;
    proxy_send_timeout 360;
    proxy_connect_timeout 360;
  '';

in

{
  meta.buildDocsInSandbox = false;

  options.services.frigate = with types; {
    enable = mkEnableOption "Frigate NVR";

    package = mkPackageOption pkgs "frigate" { };

    hostname = mkOption {
      type = str;
      example = "frigate.exampe.com";
      description = ''
        Hostname of the nginx vhost to configure.

        Only nginx is supported by upstream for direct reverse proxying.
      '';
    };

    settings = mkOption {
      type = submodule {
        freeformType = format.type;
        options = {
          cameras = mkOption {
            type = attrsOf cameraFormat;
            description = ''
              Attribute set of cameras configurations.

              https://docs.frigate.video/configuration/cameras
            '';
          };

          database = {
            path = mkOption {
              type = path;
              default = "/var/lib/frigate/frigate.db";
              description = ''
                Path to the SQLite database used
              '';
            };
          };

          mqtt = {
            enabled = mkEnableOption "MQTT support";

            host = mkOption {
              type = nullOr str;
              default = null;
              example = "mqtt.example.com";
              description = ''
                MQTT server hostname
              '';
            };
          };
        };
      };
      default = { };
      description = ''
        Frigate configuration as a nix attribute set.

        See the project documentation for how to configure frigate.
        - [Creating a config file](https://docs.frigate.video/guides/getting_started)
        - [Configuration reference](https://docs.frigate.video/configuration/index)
      '';
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      additionalModules = with pkgs.nginxModules; [
        develkit
        secure-token
        set-misc
        vod
      ];
      recommendedProxySettings = mkDefault true;
      recommendedGzipSettings = mkDefault true;
      mapHashBucketSize = mkDefault 128;
      upstreams = {
        frigate-api.servers = {
          "127.0.0.1:5001" = { };
        };
        frigate-mqtt-ws.servers = {
          "127.0.0.1:5002" = { };
        };
        frigate-jsmpeg.servers = {
          "127.0.0.1:8082" = { };
        };
        frigate-go2rtc.servers = {
          "127.0.0.1:1984" = { };
        };
      };
      proxyCachePath."frigate" = {
        enable = true;
        keysZoneSize = "10m";
        keysZoneName = "frigate_api_cache";
        maxSize = "10m";
        inactive = "1m";
        levels = "1:2";
      };
      # Based on https://github.com/blakeblackshear/frigate/blob/v0.13.1/docker/main/rootfs/usr/local/nginx/conf/nginx.conf
      virtualHosts."${cfg.hostname}" = {
        locations = {
          # auth_location.conf
          "/auth" = {
            proxyPass = "http://frigate-api/auth";
            extraConfig = ''
              internal;

              # Strip all request headers
              proxy_pass_request_headers off;

              # Pass info about the request
              proxy_set_header X-Original-Method $request_method;
              proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
              proxy_set_header X-Server-Port $server_port;
              proxy_set_header Content-Length "";

              # Pass along auth related info
              proxy_set_header Authorization $http_authorization;
              proxy_set_header Cookie $http_cookie;
              proxy_set_header X-CSRF-TOKEN "1";

              # Pass headers for common auth proxies
              proxy_set_header Remote-User $http_remote_user;
              proxy_set_header Remote-Groups $http_remote_groups;
              proxy_set_header Remote-Email $http_remote_email;
              proxy_set_header Remote-Name $http_remote_name;
              proxy_set_header X-Forwarded-User $http_x_forwarded_user;
              proxy_set_header X-Forwarded-Groups $http_x_forwarded_groups;
              proxy_set_header X-Forwarded-Email $http_x_forwarded_email;
              proxy_set_header X-Forwarded-Preferred-Username $http_x_forwarded_preferred_username;
              proxy_set_header X-authentik-username $http_x_authentik_username;
              proxy_set_header X-authentik-groups $http_x_authentik_groups;
              proxy_set_header X-authentik-email $http_x_authentik_email;
              proxy_set_header X-authentik-name $http_x_authentik_name;
              proxy_set_header X-authentik-uid $http_x_authentik_uid;

              ${nginxProxySettings}
            '';
          };
          "/vod/" = {
            extraConfig = nginxAuthRequest + ''
              aio threads;
              vod hls;

              secure_token $args;
              secure_token_types application/vnd.apple.mpegurl;

              add_header Cache-Control "no-store";
              expires off;
            '';
          };
          "/stream/" = {
            alias = "/var/cache/frigate/stream/";
            extraConfig = nginxAuthRequest + ''
              add_header Cache-Control "no-store";
              expires off;

              types {
                  application/dash+xml mpd;
                  application/vnd.apple.mpegurl m3u8;
                  video/mp2t ts;
                  image/jpeg jpg;
              }
            '';
          };
          "/clips/" = {
            root = "/var/lib/frigate";
            extraConfig = nginxAuthRequest + ''
              types {
                  video/mp4 mp4;
                  image/jpeg jpg;
              }

              expires 7d;
              add_header Cache-Control "public";
              autoindex on;
            '';
          };
          "/cache/" = {
            alias = "/var/cache/frigate/";
            extraConfig = ''
              internal;
            '';
          };
          "/recordings/" = {
            root = "/var/lib/frigate";
            extraConfig = nginxAuthRequest + ''
              types {
                  video/mp4 mp4;
              }

              autoindex on;
              autoindex_format json;
            '';
          };
          "/exports/" = {
            root = "/var/lib/frigate";
            extraConfig = nginxAuthRequest + ''
              types {
                video/mp4 mp4;
              }

              autoindex on;
              autoindex_format json;
            '';
          };
          "/ws" = {
            proxyPass = "http://frigate-mqtt-ws/";
            proxyWebsockets = true;
            extraConfig = nginxAuthRequest + nginxProxySettings;
          };
          "/live/jsmpeg" = {
            proxyPass = "http://frigate-jsmpeg/";
            proxyWebsockets = true;
            extraConfig = nginxAuthRequest + nginxProxySettings;
          };
          # frigate lovelace card uses this path
          "/live/mse/api/ws" = {
            proxyPass = "http://frigate-go2rtc/api/ws";
            proxyWebsockets = true;
            extraConfig = nginxAuthRequest + nginxProxySettings + ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          "/live/webrtc/api/ws" = {
            proxyPass = "http://frigate-go2rtc/api/ws";
            proxyWebsockets = true;
            extraConfig = nginxAuthRequest + nginxProxySettings + ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          # pass through go2rtc player
          "/live/webrtc/webrtc.html" = {
            proxyPass = "http://frigate-go2rtc/webrtc.html";
            extraConfig = nginxAuthRequest + nginxProxySettings + ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          # frontend uses this to fetch the version
          "/api/go2rtc/api" = {
            proxyPass = "http://frigate-go2rtc/api";
            extraConfig = nginxAuthRequest + nginxProxySettings + ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          # integrationn uses this to add webrtc candidate
          "/api/go2rtc/webrtc" = {
            proxyPass = "http://frigate-go2rtc/api/webrtc";
            proxyWebsockets = true;
            extraConfig = nginxAuthRequest + nginxProxySettings + ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          "~* /api/.*\.(jpg|jpeg|png|webp|gif)$" = {
            proxyPass = "http://frigate-api";
            extraConfig = nginxAuthRequest + nginxProxySettings + ''
              rewrite ^/api/(.*)$ $1 break;
            '';
          };
          "/api/" = {
            proxyPass = "http://frigate-api/";
            extraConfig = nginxAuthRequest + nginxProxySettings + ''
              add_header Cache-Control "no-store";
              expires off;

              proxy_cache frigate_api_cache;
              proxy_cache_lock on;
              proxy_cache_use_stale updating;
              proxy_cache_valid 200 5s;
              proxy_cache_bypass $http_x_cache_bypass;
              proxy_no_cache $should_not_cache;
              add_header X-Cache-Status $upstream_cache_status;

              location /api/vod/ {
                  ${nginxAuthRequest}
                  proxy_pass http://frigate-api/vod/;
                  proxy_cache off;
                  add_header Cache-Control "no-store";
                  ${nginxProxySettings}
              }

              location /api/login {
                  auth_request off;
                  rewrite ^/api(/.*)$ $1 break;
                  proxy_pass http://frigate-api;
                  ${nginxProxySettings}
              }

              location /api/stats {
                  ${nginxAuthRequest}
                  access_log off;
                  rewrite ^/api/(.*)$ $1 break;
                  add_header Cache-Control "no-store";
                  proxy_pass http://frigate-api;
                  ${nginxProxySettings}
              }

              location /api/version {
                  ${nginxAuthRequest}
                  access_log off;
                  rewrite ^/api/(.*)$ $1 break;
                  add_header Cache-Control "no-store";
                  proxy_pass http://frigate-api;
                  ${nginxProxySettings}
              }
            '';
          };
          "/assets/" = {
            root = cfg.package.web;
            extraConfig = ''
              access_log off;
              expires 1y;
              add_header Cache-Control "public";
            '';
          };
          "/" = {
            root = cfg.package.web;
            tryFiles = "$uri $uri.html $uri/ /index.html";
            extraConfig = ''
              add_header Cache-Control "no-store";
              expires off;
            '';
          };
        };
        extraConfig = ''
          # vod settings
          vod_base_url "";
          vod_segments_base_url "";
          vod_mode mapped;
          vod_max_mapping_response_size 1m;
          vod_upstream_location /api;
          vod_align_segments_to_key_frames on;
          vod_manifest_segment_durations_mode accurate;
          vod_ignore_edit_list on;
          vod_segment_duration 10000;
          vod_hls_mpegts_align_frames off;
          vod_hls_mpegts_interleave_frames on;

          # file handle caching / aio
          open_file_cache max=1000 inactive=5m;
          open_file_cache_valid 2m;
          open_file_cache_min_uses 1;
          open_file_cache_errors on;
          aio on;

          # https://github.com/kaltura/nginx-vod-module#vod_open_file_thread_pool
          vod_open_file_thread_pool default;

          # vod caches
          vod_metadata_cache metadata_cache 512m;
          vod_mapping_cache mapping_cache 5m 10m;

          # gzip manifest
          gzip_types application/vnd.apple.mpegurl;
        '';
      };
      appendConfig = ''
        rtmp {
            server {
                listen 1935;
                chunk_size 4096;
                allow publish 127.0.0.1;
                deny publish all;
                allow play all;
                application live {
                    live on;
                    record off;
                    meta copy;
                }
            }
        }
      '';
      appendHttpConfig = ''
        map $sent_http_content_type $should_not_cache {
          'application/json' 0;
          default 1;
        }
      '';
    };

    systemd.services.nginx.serviceConfig.SupplementaryGroups = [
      "frigate"
    ];

    users.users.frigate = {
      isSystemUser = true;
      group = "frigate";
    };
    users.groups.frigate = { };

    systemd.services.frigate = {
      after = [
        "go2rtc.service"
        "network.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];
      environment = {
        CONFIG_FILE = format.generate "frigate.yml" filteredConfig;
        HOME = "/var/lib/frigate";
        PYTHONPATH = cfg.package.pythonPath;
      };
      path = with pkgs; [
        # unfree:
        # config.boot.kernelPackages.nvidiaPackages.latest.bin
        ffmpeg-headless
        libva-utils
        procps
        radeontop
      ] ++ lib.optionals (!stdenv.isAarch64) [
        # not available on aarch64-linux
        intel-gpu-tools
      ];
      serviceConfig = {
        ExecStart = "${cfg.package.python.interpreter} -m frigate";
        Restart = "on-failure";

        User = "frigate";
        Group = "frigate";

        UMask = "0027";

        StateDirectory = "frigate";
        StateDirectoryMode = "0750";

        # Caches
        PrivateTmp = true;
        CacheDirectory = "frigate";
        CacheDirectoryMode = "0750";

        # Sockets/IPC
        RuntimeDirectory = "frigate";
      };
    };
  };
}
