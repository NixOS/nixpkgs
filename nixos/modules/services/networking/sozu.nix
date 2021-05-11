{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.sozu;
  format = pkgs.formats.toml {};

  globalSettings = format.generate "global.toml" cfg.global;
  optionalSettings = format.generate "optional.toml" cfg.optional;
  configFile = pkgs.writeText "config.toml" ''
    ${fileContents globalSettings}

    ${fileContents optionalSettings}
  '';
in
{
  options.services.sozu = {
    enable = mkEnableOption "Sozu server";

    package = mkOption {
      type = types.package;
      default = pkgs.sozu;
      description = "Sozu package to use.";
    };

    global = mkOption {
      default = {};
      description = ''
        Global settings that will be parsed into Sozu's <literal>config.toml</literal>.
        Documentation <link xlink:href="https://github.com/sozu-proxy/sozu/blob/master/doc/configure.md">here</link>.
      '';
      type = types.submodule {

        options = {
          saved_state = mkOption {
            type = types.str;
            default = "/run/sozu/state.json";
            description = ''
              Path to a file sozu can use to load an initial configuration state
              for its routing. You can generate this file from sozu's current
              routing by running the command <literal>sozuctl state save -f state.json</literal>.
            '';
          };

          automatic_save_state = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = ''
              Save the configuration to the saved_state file every time we
              receive a configuration message on the configuration socket.
              Defaults to false, and will not work if the 'saved_state' option is
              not set.
            '';
          };

          log_level = mkOption {
            type = types.str;
            default = "info";
            description = ''
              Logging verbosity. Possible values are "error", "warn", "info",
              "debug" and "trace". For performance reasons, the logs at "debug"
              or "trace" level are not compiled by default. To activate them,
              pass the "logs-debug" and "logs-trace" compilation options to cargo.
            '';
          };

          log_target = mkOption {
            type = types.str;
            default = "stdout";
            description = ''
              Where the logs will be sent. It defaults to sending the logs on
              standard output.
              UDP address: "udp://127.0.0.1:9876"
              To a TCP address: "tcp://127.0.0.1:9876"
              To a unix socket: "unix:///var/sozu/logs
              To a file: "file:///var/logs/sozu.log"
              To stdout: "stdout"
            '';
          };

          log_access_target = mkOption {
            type = types.str;
            default = "file:///dev/null";
            example = "file:///var/logs/sozu-access.log";
            description = ''
              Optional different target for access logs (IP addresses, domains,
              URI, HTTP status, etc).
              UDP address: "udp://127.0.0.1:9876"
              To a TCP address: "tcp://127.0.0.1:9876"
              To a unix socket: "unix:///var/sozu/access_logs
              To a file: "file:///var/logs/sozu-access.log"
            '';
          };

          command_socket = mkOption {
            type = types.str;
            default = "/run/sozu/sozu.sock";
            description = ''
              Path to the unix socket file used to send commands to sozu.
              Default value points to "sozu.sock" file in the current directory.
            '';
          };

          command_buffer_size = mkOption {
            type = types.int;
            default = 1000000;
            example = 16384;
            description = ''
              Size in bytes of the buffer used by the command socket protocol. If the message
              sent to sozu is too large, or the data that sozu must return is too large, the
              buffer will grow up to max_command_buffer_size. If the buffer is still not large
              enough sozu, will close the connection.
            '';
          };

          max_command_buffer_size = mkOption {
            type = types.int;
            default = cfg.global.command_buffer_size * 2;
            example = 163840;
            description = ''
              Maximum size in bytes of the buffer
              used by the command socket protocol.
            '';
          };

          worker_count = mkOption {
            type = types.int;
            default = 2;
            description = ''
              The number of worker processes that will handle traffic.
            '';
          };

          worker_automatic_restart = mkOption {
            type = types.bool;
            default = true;
            example = false;
            description = ''
              Indicates if workers should be automatically restarted if they
              crash / hang should be true for production and false for
              development.
            '';
          };

          handle_process_affinity = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = ''
              Indicates if worker process will be pinned on a core. If you
              activate this, be sure that you do not have more workers than CPU
              cores (and leave at least one core for the kernel and the master
              process).
            '';
          };

          max_connections = mkOption {
            type = types.int;
            # current max file descriptor soft limit is: 1024
            # the worker needs two file descriptors per client connection
            default = 1024 / 2;
            example = 500;
            description = ''
              Maximum number of connections to a worker. If it reached that
              number and there are new connections available, the worker will
              accept and close them immediately to indicate it is too busy to
              handle traffic.
            '';
          };

          max_buffers = mkOption {
            type = types.int;
            default = 1000;
            example = 500;
            description = ''
              Maximum number of buffers used by the protocol implementations for
              active connections (ie currently serving a request).
              For now, you should estimate that
              <literal>max_buffers = number of concurrent requests * 2</literal>.
            '';
          };

          buffer_size = mkOption {
            type = types.int;
            default = 16384;
            description = ''
              Size of the buffers used by the protocol implementations. Each worker will
              preallocate max_buffers * 2 * buffer_size bytes, so you should plan for this
              memory usage. If you plan to use sozu's runtime upgrade feature, you should
              leave enough memory for one more worker (also for the kernel, etc), so total
              RAM should be larger than <literal>(worker count + 1) * max_buffers * 2 * buffer_size bytes</literal>.
            '';
          };

          ctl_command_timeout = mkOption {
            type = types.int;
            default = 1000;
            description = ''
              How much time (in milliseconds) sozuctl will wait for a command to complete.
            '';
          };

          pid_file_path = mkOption {
            type = types.str;
            default = "/run/sozu/sozu.pid";
            description = ''
              PID file is a file containing the PID of the master process of sozu.
              It can be helpful to help systemd or any other service system to keep track
              of the main process across upgrades. PID file is not created unless this option
              is set or if SOZU_PID_FILE_PATH environment variable was defined at build time.
            '';
          };

          tls_provider = mkOption {
            type = types.enum [ "openssl" "rustls" ];
            default = "rustls";
            description = ''
              Defines how the TLS protocol will be handled by sozu. Possible values
              are "openssl" or "rustls". The "openssl" option will only work if sozu
              was built with the "use-openssl" feature.
            '';
          };

          front_timeout = mkOption {
            type = types.int;
            default = 60;
            description = ''
              Maximum time of inactivity for a front socket, in seconds.
            '';
          };

          zombie_check_interval = mkOption {
            type = types.int;
            default = 1800;
            description = ''
              Duration between zombie checks, in seconds.
              In case of bugs in sozu's event loop and protocol implementations,
              some client sessions could be stuck, not receiving any more event,
              and consuming resources. Sozu verifies regularly if there are such
              zombie sessions, logs their state and removes them.
            '';
          };

          activate_listeners = mkOption {
            type = types.bool;
            default = true;
            example = false;
            description = ''
              By default, all listeners start a TCP listen socket on startup.
              If set to false, this option will prevent them from listening. You can then add
              the complete configuration, and send an ActivateListener message afterwards.
            '';
          };

        };

      };

    };

    optional = mkOption {
      description = ''
        Optional settings that will be parsed into Sozu's <literal>config.toml</literal>.
        Documentation <link xlink:href="https://github.com/sozu-proxy/sozu/blob/master/doc/configure.md">here</link>.
        Also see example.
      '';
      default = {};
      example = {
        listeners = [
          # Example for an HTTP (plaintext) listener
          {
            # Possible values are http, https or tcp
            protocol = "http";
            # Listening address
            address = "127.0.0.1:8080";

            # Specify a different IP than the one the socket sees, for logs and
            # forwarded headers
            public_address = "1.2.3.4:80";

            # Configures the client socket to receive a PROXY protocol header
            #expect_proxy = false;

            # Path to custom 404 and 503 answers
            # A 404 response is sent when sozu does not know about the requested domain or path
            # A 503 response is sent if there are no backend servers available
            answer_404 = "../lib/assets/404.html";
            answer_503 = "../lib/assets/503.html";

            # Defines the sticky session cookie's name, if `sticky_session` is
            # activated format an application. Defaults to "SOZUBALANCEID"
            sticky_name = "SOZUBALANCEID";
          }

          # Example for an HTTPS (OpenSSL or rustls based) listener
          {
            # Possible values are http, https or tcp
            protocol = "https";
            # Listening address
            address = "127.0.0.1:8443";

            # Specify a different IP than the one the socket sees, for logs and
            # forwarded headers
            #public_address = "1.2.3.4:81";

            # Configures the client socket to receive a PROXY protocol header
            # This option is incompatible with public_addresss
            #expect_proxy = false;

            # Path to custom 404 and 503 answers
            # A 404 response is sent when sozu does not know about the
            # requested domain or path
            # A 503 response is sent if there are no backend servers available
            answer_404 = "../lib/assets/404.html";
            answer_503 = "../lib/assets/503.html";

            # Defines the sticky session cookie's name, if `sticky_session` is
            # activated format an application. Defaults to "SOZUBALANCEID"
            sticky_name = "SOZUBALANCEID";

            # Supported TLS versions. Possible values are "SSLv2", "SSLv3",
            # "TLSv1", "TLSv1.1", "TLSv1.2", "TLSv1.3". Defaults to "TLSv1.2"
            tls_versions = [ "TLSv1.2" ];

            # Option specific to Openssl based HTTPS listeners
            #cipher_list = "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256";

            # Option specific to rustls based HTTPS listeners
            rustls_cipher_list = [ "TLS13_CHACHA20_POLY1305_SHA256" ];
          }
        ];

        applications = {
          # Every application has an "application ID", here it is "MyApp".
          # This is an example of a routing configuration for the HTTP and HTPPS proxies
          MyApp = {
            # The protocol option indicates if we will use HTTP or TCP proxying
            # Possible values are thus "http" and "tcp"
            # HTTPS proxies will use http here
            protocol = "http";

            # Per application load balancing algorithm
            # The possible values are "roundrobin" and "random"
            # Defaults to "roundrobin"
            load_balancing_policy = "roundrobin";

            # Force application to redirect http traffic to https
            #https_redirect = true

            # Frontends configuration:
            # This specifies the listeners, domains, and certificates that will be configured for an application.
            # Possible frontend options:
            # - address: TCP listener.
            # - hostname: Hostname of the application.
            # - path_begin = "/api" # Optional. An application can receive requests going to a hostname and path prefix.
            # - sticky_session = false # Activates sticky sessions for this application.
            # - https_redirect = false # Activates automatic redirection to HTTPS for this application.
            frontends = [
              {
                address = "0.0.0.0:8080";
                hostname = "lolcatho.st";
              }

              {
                address = "0.0.0.0:8443";
                hostname = "lolcatho.st";
                certificate = "../lib/assets/certificate.pem";
                key = "../lib/assets/key.pem";
                certificate_chain = "../lib/assets/certificate_chain.pem";
              }
            ];

            # Backend configuration:
            # This indicates the backend servers used by the application.
            # Possible options:
            # - addresss: IP and port of the backend server.
            # - weight: Weight used by the load balancing algorithm.
            # - sticky-id: Sticky session identifier.
            backends = [
              {
                address = "127.0.0.1:1026";
              }
            ];
          };

          TcpTest = {
            protocol = "tcp";

            frontends = [
              {
                address = "0.0.0.0:8081";
              }
            ];

            # Activates the proxy protocol to send IP information to the backend
            send_proxy = false;

            backends = [
              {
                address = "127.0.0.1:4000";
                weight = 100;
              }
              {
                address = "127.0.0.1:4001";
                weight = 50;
              }
            ];
          };
        };

        metrics = {
          address = "127.0.0.1:8125";
          # use InfluxDB's statsd protocol flavor to add tags
          tagged_metrics = false;
          # metrics key prefix
          prefix = "sozu";
        };
      };
      type = types.submodule
        {
          freeformType = format.type;
        };
    };

  };

  config = mkIf
    cfg.enable
    {
      environment.systemPackages = with pkgs; [
        cfg.package
      ];

      users.groups.sozu = {};
      users.users.sozu = {
        description = "Sozu Daemon User";
        group = "sozu";
        isSystemUser = true;
      };

      systemd.services.sozu = {
        description = "Sozu - A HTTP reverse proxy, configurable at runtime, fast and safe, built in Rust.";
        after = [ "network.target" ];
        wants = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          PIDFile = "/run/sozu/sozu.pid";
          ExecStart = "${cfg.package}/bin/sozu start --config ${configFile}";
          ExecReload = "${cfg.package}/bin/sozuctl --config ${configFile} reload";
          Restart = "on-failure";
          User = "sozu";
          Group = "sozu";
          RuntimeDirectory = "sozu";
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        };

      };

    };

  meta = with lib; {
    maintainers = with maintainer; [ netcrns ];
  };

}
