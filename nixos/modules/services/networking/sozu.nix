{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.sozu;
  format = pkgs.formats.toml {};

  settings = format.generate "settings.toml" cfg.settings;

  configFile = pkgs.writeText "config.toml" ''
    ${fileContents settings}
    ${optionalString (cfg.extraConfig != null) cfg.extraConfig}
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

    settings = mkOption {
      default = {};
      description = ''
        Settings that will be parsed into Sozu's <literal>config.toml</literal>.
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
            default = cfg.settings.command_buffer_size * 2;
            example = "163840";
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
            default = 10000;
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

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra configuration for <link xlink:href="https://github.com/sozu-proxy/sozu/blob/master/doc/configure.md#metrics">metrics</link>, <link xlink:href="https://github.com/sozu-proxy/sozu/blob/master/doc/configure.md#listeners">listeners</link>,
        and <link xlink:href="https://github.com/sozu-proxy/sozu/blob/master/doc/configure.md#applications">applications</link>.
      '';
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sozu
    ];

    systemd.services.sozu = {
      description = "Sozu - A HTTP reverse proxy, configurable at runtime, fast and safe, built in Rust.";
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        # Create the proper run directory
        mkdir -p /run/sozu
        chown -R sozu /run/sozu
      '';

      serviceConfig = {
        PIDFile = "/run/sozu/sozu.pid";
        ExecStart = "${cfg.package}/bin/sozu start --config ${configFile}";
        Restart = "on-failure";
      };

    };

    users.users.sozu = {
      description = "Sozu Daemon User";
      isSystemUser = true;
    };

  };

  meta = with lib; {
    maintainers = with maintainer; [ netcrns ];
  };
}
