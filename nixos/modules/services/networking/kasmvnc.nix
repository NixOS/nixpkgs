{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kasmvnc;

  defaultDESession = config.services.displayManager.defaultSession;

  kasmvncConfig = {
    desktop = {
      resolution = {
        width = cfg.desktop.resolution.width;
        height = cfg.desktop.resolution.height;
      };
      allow_resize = cfg.desktop.allow_resize;
      pixel_depth = cfg.desktop.pixel_depth;
      gpu = {
        hw3d = cfg.desktop.gpu.hw3d;
        drinode = cfg.desktop.gpu.drinode;
      };
    };
    network = {
      protocol = cfg.network.protocol;
      interface = cfg.network.interface;
      websocket_port = cfg.network.websocket_port;
      use_ipv4 = cfg.network.use_ipv4;
      use_ipv6 = cfg.network.use_ipv6;
      udp = {
        public_ip = cfg.network.udp.public_ip;
        port = cfg.network.udp.port;
        stun_server = cfg.network.udp.stun_server;
      };
      ssl = {
        pem_certificate = cfg.network.ssl.pem_certificate;
        pem_key = cfg.network.ssl.pem_key;
        require_ssl = cfg.network.ssl.require_ssl;
      };
    };
    user_session = {
      new_session_disconnects_existing_exclusive_session =
        cfg.user_session.new_session_disconnects_existing_exclusive_session;
      concurrent_connections_prompt = cfg.user_session.concurrent_connections_prompt;
      concurrent_connections_prompt_timeout = cfg.user_session.concurrent_connections_prompt_timeout;
      idle_timeout = cfg.user_session.idle_timeout;
    };
    keyboard = {
      remap_keys = cfg.keyboard.remap_keys;
      ignore_numlock = cfg.keyboard.ignore_numlock;
      raw_keyboard = cfg.keyboard.raw_keyboard;
    };
    pointer = {
      enabled = cfg.pointer.enabled;
    };
    runtime_configuration = {
      allow_client_to_override_kasm_server_settings =
        cfg.runtime_configuration.allow_client_to_override_kasm_server_settings;
      allow_override_standard_vnc_server_settings =
        cfg.runtime_configuration.allow_override_standard_vnc_server_settings;
      allow_override_list = cfg.runtime_configuration.allow_override_list;
    };
    logging = {
      log_writer_name = cfg.logging.log_writer_name;
      log_dest = cfg.logging.log_dest;
      level = cfg.logging.level;
    };
    security = {
      brute_force_protection = {
        blacklist_threshold = cfg.security.brute_force_protection.blacklist_threshold;
        blacklist_timeout = cfg.security.brute_force_protection.blacklist_timeout;
      };
    };
    data_loss_prevention = {
      visible_region = {
        concealed_region = {
          allow_click_down = cfg.data_loss_prevention.visible_region.concealed_region.allow_click_down;
          allow_click_release = cfg.data_loss_prevention.visible_region.concealed_region.allow_click_release;
        };
      };
      clipboard = {
        delay_between_operations = cfg.data_loss_prevention.clipboard.delay_between_operations;
        allow_mimetypes = cfg.data_loss_prevention.clipboard.allow_mimetypes;
        server_to_client = {
          enabled = cfg.data_loss_prevention.clipboard.server_to_client.enabled;
          size = cfg.data_loss_prevention.clipboard.server_to_client.size;
          primary_clipboard_enabled =
            cfg.data_loss_prevention.clipboard.server_to_client.primary_clipboard_enabled;
        };
        client_to_server = {
          enabled = cfg.data_loss_prevention.clipboard.client_to_server.enabled;
          size = cfg.data_loss_prevention.clipboard.client_to_server.size;
        };
        keyboard = {
          enabled = cfg.data_loss_prevention.clipboard.keyboard.enabled;
          rate_limit = cfg.data_loss_prevention.clipboard.keyboard.rate_limit;
        };
        logging = {
          level = cfg.data_loss_prevention.clipboard.logging.level;
        };
      };
    };
    encoding = {
      max_frame_rate = cfg.encoding.max_frame_rate;
      full_frame_updates = cfg.encoding.full_frame_updates;
      rect_encoding_mode = {
        min_quality = cfg.encoding.rect_encoding_mode.min_quality;
        max_quality = cfg.encoding.rect_encoding_mode.max_quality;
        consider_lossless_quality = cfg.encoding.rect_encoding_mode.consider_lossless_quality;
        rectangle_compress_threads = cfg.encoding.rect_encoding_mode.rectangle_compress_threads;
      };
      video_encoding_mode = {
        jpeg_quality = cfg.encoding.video_encoding_mode.jpeg_quality;
        webp_quality = cfg.encoding.video_encoding_mode.webp_quality;
        max_resolution = {
          width = cfg.encoding.video_encoding_mode.max_resolution.width;
          height = cfg.encoding.video_encoding_mode.max_resolution.height;
        };
        enter_video_encoding_mode = {
          time_threshold = cfg.encoding.video_encoding_mode.enter_video_encoding_mode.time_threshold;
          area_threshold = cfg.encoding.video_encoding_mode.enter_video_encoding_mode.area_threshold;
        };
        exit_video_encoding_mode = {
          time_threshold = cfg.encoding.video_encoding_mode.exit_video_encoding_mode.time_threshold;
        };
        logging = {
          level = cfg.encoding.video_encoding_mode.logging.level;
        };
        scaling_algorithm = cfg.encoding.video_encoding_mode.scaling_algorithm;
      };
      compare_framebuffer = cfg.encoding.compare_framebuffer;
      zrle_zlib_level = cfg.encoding.zrle_zlib_level;
      hextile_improved_compression = cfg.encoding.hextile_improved_compression;
    };
    server = {
      http = {
        headers = cfg.server.http.headers;
        httpd_directory = cfg.server.http.httpd_directory;
      };
      advanced = {
        x_font_path = cfg.server.advanced.x_font_path;
        kasm_password_file = lib.mkIf cfg.server.advanced.kasm_password_file cfg.server.advanced.kasm_password_file;
        x_authority_file = cfg.server.advanced.x_authority_file;
      };
      auto_shutdown = {
        no_user_session_timeout = cfg.server.auto_shutdown.no_user_session_timeout;
        active_user_session_timeout = cfg.server.auto_shutdown.active_user_session_timeout;
        inactive_user_session_timeout = cfg.server.auto_shutdown.inactive_user_session_timeout;
      };
    };
    command_line = {
      prompt = cfg.command_line.prompt;
    };
  };

  format = pkgs.formats.yaml { };
  configFileName = "/etc/kasmvnc/kasmvnc.yaml";
  configFile = format.generate configFileName kasmvncConfig;

in
{
  options = {
    services.kasmvnc = {
      enable = lib.mkEnableOption "KasmVNC service";

      desktop = {
        session = lib.mkOption {
          type = lib.types.str;
          example = "plasma";
          description = "The Desktop Environment Session to use for the VNC Server";
        };
        resolution = {
          width = lib.mkOption {
            type = lib.types.int;
            default = 1024;
            description = "Desktop width resolution.";
          };
          height = lib.mkOption {
            type = lib.types.int;
            default = 768;
            description = "Desktop height resolution.";
          };
        };
        allow_resize = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Allow clients to resize the desktop.";
        };
        pixel_depth = lib.mkOption {
          type = lib.types.int;
          default = 24;
          description = "Pixel depth.";
        };
        gpu = {
          hw3d = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable hardware 3D acceleration if possible.";
          };
          drinode = lib.mkOption {
            type = lib.types.path;
            default = "/dev/dri/renderD128";
            description = "DRI node for GPU acceleration.";
          };
        };
      };

      network = {
        protocol = lib.mkOption {
          type = lib.types.str;
          default = "http";
          description = "Network protocol (http or https).";
        };
        interface = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "Network interface to bind to.";
        };
        websocket_port = lib.mkOption {
          type = lib.types.str;
          default = "auto";
          description = "WebSocket port (use 'auto' for automatic).";
        };
        use_ipv4 = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Use IPv4.";
        };
        use_ipv6 = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Use IPv6.";
        };
        udp = {
          public_ip = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "Public IP for UDP.";
          };
          port = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "UDP port.";
          };
          stun_server = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "STUN server.";
          };
        };
        ssl = {
          pem_certificate = lib.mkOption {
            type = lib.types.path;
            default = "/etc/ssl/certs/ssl-cert-snakeoil.pem";
            description = "Path to SSL certificate file.";
          };
          pem_key = lib.mkOption {
            type = lib.types.path;
            default = "/etc/ssl/private/ssl-cert-snakeoil.key";
            description = "Path to SSL key file.";
          };
          require_ssl = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Require SSL.";
          };
        };
      };

      user_session = {
        new_session_disconnects_existing_exclusive_session = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "If true, a new session disconnects existing exclusive session.";
        };
        concurrent_connections_prompt = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Prompt on concurrent connections.";
        };
        concurrent_connections_prompt_timeout = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = "Timeout for concurrent connections prompt.";
        };
        idle_timeout = lib.mkOption {
          type = lib.types.str;
          default = "never";
          description = "Idle timeout (e.g. 'never').";
        };
      };

      keyboard = {
        remap_keys = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          description = "Map of keys to remap, empty by default.";
        };
        ignore_numlock = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Ignore NumLock state.";
        };
        raw_keyboard = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use raw keyboard events.";
        };
      };

      pointer = {
        enabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable pointer input.";
        };
      };

      runtime_configuration = {
        allow_client_to_override_kasm_server_settings = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Allow client to override Kasm server settings.";
        };
        allow_override_standard_vnc_server_settings = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Allow override of standard VNC server settings.";
        };
        allow_override_list = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "pointer.enabled"
            "data_loss_prevention.clipboard.server_to_client.enabled"
            "data_loss_prevention.clipboard.client_to_server.enabled"
            "data_loss_prevention.clipboard.server_to_client.primary_clipboard_enabled"
          ];
          description = "List of settings clients are allowed to override.";
        };
      };

      logging = {
        log_writer_name = lib.mkOption {
          type = lib.types.str;
          default = "all";
          description = "Log writer name.";
        };
        log_dest = lib.mkOption {
          type = lib.types.str;
          default = "logfile";
          description = "Log destination.";
        };
        level = lib.mkOption {
          type = lib.types.int;
          default = 30;
          description = "Logging level.";
        };
      };

      security = {
        brute_force_protection = {
          blacklist_threshold = lib.mkOption {
            type = lib.types.int;
            default = 5;
            description = "Brute force protection blacklist threshold.";
          };
          blacklist_timeout = lib.mkOption {
            type = lib.types.int;
            default = 10;
            description = "Brute force blacklist timeout.";
          };
        };
      };

      data_loss_prevention = {
        visible_region = {
          concealed_region = {
            allow_click_down = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Allow clicking down in concealed region.";
            };
            allow_click_release = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Allow releasing click in concealed region.";
            };
          };
        };
        clipboard = {
          delay_between_operations = lib.mkOption {
            type = lib.types.str;
            default = "none";
            description = "Clipboard delay between operations.";
          };
          allow_mimetypes = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "chromium/x-web-custom-data"
              "text/html"
              "image/png"
            ];
            description = "Allowed clipboard mimetypes.";
          };
          server_to_client = {
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable server-to-client clipboard.";
            };
            size = lib.mkOption {
              type = lib.types.str;
              default = "unlimited";
              description = "Max size for server-to-client clipboard.";
            };
            primary_clipboard_enabled = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable primary clipboard server-to-client.";
            };
          };
          client_to_server = {
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable client-to-server clipboard.";
            };
            size = lib.mkOption {
              type = lib.types.str;
              default = "unlimited";
              description = "Max size for client-to-server clipboard.";
            };
          };
          keyboard = {
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable keyboard input.";
            };
            rate_limit = lib.mkOption {
              type = lib.types.str;
              default = "unlimited";
              description = "Rate limit for keyboard input.";
            };
          };
          logging = {
            level = lib.mkOption {
              type = lib.types.str;
              default = "off";
              description = "Data loss prevention logging level.";
            };
          };
        };
      };

      encoding = {
        max_frame_rate = lib.mkOption {
          type = lib.types.int;
          default = 60;
          description = "Maximum frame rate.";
        };
        full_frame_updates = lib.mkOption {
          type = lib.types.str;
          default = "none";
          description = "Full frame updates setting.";
        };
        rect_encoding_mode = {
          min_quality = lib.mkOption {
            type = lib.types.int;
            default = 7;
            description = "Minimum quality for rect encoding.";
          };
          max_quality = lib.mkOption {
            type = lib.types.int;
            default = 8;
            description = "Maximum quality for rect encoding.";
          };
          consider_lossless_quality = lib.mkOption {
            type = lib.types.int;
            default = 10;
            description = "Consider lossless quality level.";
          };
          rectangle_compress_threads = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "Number of threads for rectangle compression.";
          };
        };

        video_encoding_mode = {
          jpeg_quality = lib.mkOption {
            type = lib.types.int;
            default = -1;
            description = "JPEG quality for video mode.";
          };
          webp_quality = lib.mkOption {
            type = lib.types.int;
            default = -1;
            description = "WebP quality for video mode.";
          };
          max_resolution = {
            width = lib.mkOption {
              type = lib.types.int;
              default = 1920;
              description = "Max video mode width.";
            };
            height = lib.mkOption {
              type = lib.types.int;
              default = 1080;
              description = "Max video mode height.";
            };
          };
          enter_video_encoding_mode = {
            time_threshold = lib.mkOption {
              type = lib.types.int;
              default = 5;
              description = "Time threshold to enter video mode.";
            };
            area_threshold = lib.mkOption {
              type = lib.types.str;
              default = "45%";
              description = "Area threshold to enter video mode.";
            };
          };
          exit_video_encoding_mode = {
            time_threshold = lib.mkOption {
              type = lib.types.int;
              default = 3;
              description = "Time threshold to exit video mode.";
            };
          };
          logging = {
            level = lib.mkOption {
              type = lib.types.str;
              default = "off";
              description = "Video encoding logging level.";
            };
          };
          scaling_algorithm = lib.mkOption {
            type = lib.types.str;
            default = "progressive_bilinear";
            description = "Scaling algorithm used in video mode.";
          };
        };

        compare_framebuffer = lib.mkOption {
          type = lib.types.str;
          default = "auto";
          description = "Compare framebuffer setting.";
        };
        zrle_zlib_level = lib.mkOption {
          type = lib.types.str;
          default = "auto";
          description = "Zlib level for ZRLE encoding.";
        };
        hextile_improved_compression = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Use improved compression for Hextile.";
        };
      };

      server = {
        http = {
          headers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "Cross-Origin-Embedder-Policy=require-corp"
              "Cross-Origin-Opener-Policy=same-origin"
            ];
            description = "HTTP headers to add.";
          };
          httpd_directory = lib.mkOption {
            type = lib.types.path;
            default = "/usr/share/kasmvnc/www";
            description = "HTTP directory.";
          };
        };
        advanced = {
          x_font_path = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "X font path.";
          };
          kasm_password_file = lib.mkOption {
            type = lib.types.str;
            description = "Path to kasm password file.";
          };
          x_authority_file = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "X authority file.";
          };
        };
        auto_shutdown = {
          no_user_session_timeout = lib.mkOption {
            type = lib.types.str;
            default = "never";
            description = "No user session timeout.";
          };
          active_user_session_timeout = lib.mkOption {
            type = lib.types.str;
            default = "never";
            description = "Active user session timeout.";
          };
          inactive_user_session_timeout = lib.mkOption {
            type = lib.types.str;
            default = "never";
            description = "Inactive user session timeout.";
          };
        };
      };

      command_line = {
        prompt = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable command line prompt.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable rec {
    environment.etc."kasmvnc.yaml".source = configFile;

    systemd.services.kasmvnc = {
      description = "KasmVNC server";
      after = [ "network.target" ];
      wants = [ "display-manager.service" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.kasmvnc}/bin/vncserver -select-de ${lib.cfg.desktop.session or defaultDESession}
        '';
        Restart = "always";
      };
    };
  };
}
