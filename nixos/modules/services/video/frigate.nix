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
                type = listOf (enum [ "detect" "record" "rtmp" ]);
                example = literalExpression ''
                  [ "detect" "rtmp" ]
                '';
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
        secure-token
        rtmp
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
          "/api/" = {
            proxyPass = "http://frigate-api/";
            extraConfig = ''
              proxy_cache frigate_api_cache;
              proxy_cache_lock on;
              proxy_cache_use_stale updating;
              proxy_cache_valid 200 5s;
              proxy_cache_bypass $http_x_cache_bypass;
              proxy_no_cache $should_not_cache;
              add_header X-Cache-Status $upstream_cache_status;

              location /api/vod/ {
                  proxy_pass http://frigate-api/vod/;
                  proxy_cache off;
              }

              location /api/stats {
                  access_log off;
                  rewrite ^/api/(.*)$ $1 break;
                  proxy_pass http://frigate-api;
              }

              location /api/version {
                  access_log off;
                  rewrite ^/api/(.*)$ $1 break;
                  proxy_pass http://frigate-api;
              }
            '';
          };
          "~* /api/.*\.(jpg|jpeg|png)$" = {
            proxyPass = "http://frigate-api";
            extraConfig = ''
              rewrite ^/api/(.*)$ $1 break;
            '';
          };
          "/vod/" = {
            extraConfig = ''
              aio threads;
              vod hls;

              secure_token $args;
              secure_token_types application/vnd.apple.mpegurl;

              add_header Cache-Control "no-store";
              expires off;
            '';
          };
          "/stream/" = {
            # TODO
          };
          "/ws" = {
            proxyPass = "http://frigate-mqtt-ws/";
            proxyWebsockets = true;
          };
          "/live/jsmpeg" = {
            proxyPass = "http://frigate-jsmpeg/";
            proxyWebsockets = true;
          };
          "/live/mse/" = {
            proxyPass = "http://frigate-go2rtc/";
            proxyWebsockets = true;
          };
          # frigate lovelace card uses this path
          "/live/mse/api/ws" = {
            proxyPass = "http://frigate-go2rtc/api/ws";
            proxyWebsockets = true;
            extraConfig = ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          "/live/webrtc/" = {
            proxyPass = "http://frigate-go2rtc/";
            proxyWebsockets = true;
          };
          "/live/webrtc/api/ws" = {
            proxyPass = "http://frigate-go2rtc/api/ws";
            proxyWebsockets = true;
            extraConfig = ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          # pass through go2rtc player
          "/live/webrtc/webrtc.html" = {
            proxyPass = "http://frigate-go2rtc/webrtc.html";
            proxyWebsockets = true;
            extraConfig = ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          "/api/go2rtc/api" = {
            proxyPass = "http://frigate-go2rtc/api";
            proxyWebsockets = true;
            extraConfig = ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          # integrationn uses this to add webrtc candidate
          "/api/go2rtc/webrtc" = {
            proxyPass = "http://frigate-go2rtc/api/webrtc";
            proxyWebsockets = true;
            extraConfig = ''
              limit_except GET {
                  deny  all;
              }
            '';
          };
          "/cache/" = {
            alias = "/var/cache/frigate/";
          };
          "/clips/" = {
            root = "/var/lib/frigate";
            extraConfig = ''
              types {
                  video/mp4 mp4;
                  image/jpeg jpg;
              }

              autoindex on;
            '';
          };
          "/recordings/" = {
            root = "/var/lib/frigate";
            extraConfig = ''
              types {
                  video/mp4 mp4;
              }

              autoindex on;
              autoindex_format json;
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
            tryFiles = "$uri $uri/ /index.html";
            extraConfig = ''
              add_header Cache-Control "no-store";
              expires off;

              sub_filter 'href="/BASE_PATH/' 'href="$http_x_ingress_path/';
              sub_filter 'url(/BASE_PATH/' 'url($http_x_ingress_path/';
              sub_filter '"/BASE_PATH/dist/' '"$http_x_ingress_path/dist/';
              sub_filter '"/BASE_PATH/js/' '"$http_x_ingress_path/js/';
              sub_filter '"/BASE_PATH/assets/' '"$http_x_ingress_path/assets/';
              sub_filter '"/BASE_PATH/monacoeditorwork/' '"$http_x_ingress_path/assets/';
              sub_filter 'return"/BASE_PATH/"' 'return window.baseUrl';
              sub_filter '<body>' '<body><script>window.baseUrl="$http_x_ingress_path/";</script>';
              sub_filter_types text/css application/javascript;
              sub_filter_once off;
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
      };
    };
  };
}
