{ lib, pkgs, config, ... }:
let
  cfg = config.services.matrix-corporal;
  matrix-corporal-config = pkgs.writeTextFile {
    name = "matrix-corporal-config.json";
    text = lib.generators.toJSON {} cfg.settings;
  };
in
{
  options.services.matrix-corporal = {
    enable = lib.mkEnableOption "matrix-corporal";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.matrix-corporal;
    };

    settings = lib.mkOption {
      default = {};
      type = with lib.types.submodule {
        options.Matrix.HomeserverDomainName = lib.mkOption {
          type = lib.types.str;
          description = ''
            The base domain name of your Matrix homeserver.
            This is what user identifiers contain (@user:example.com), and not necessarily the domain name where the Matrix homeserver is hosted (could actually be matrix.example.com)
          '';
        };
        options.Matrix.HomeserverAPIEndpoint = lib.mkOption {
          type = lib.types.str;
          default = "localhost:8008";
          description = ''
            A URI to the Matrix homeserver's API.
            This would normally be a local address, as it's convenient to run matrix-corporal on the same machine as Matrix Synapse.
          '';
        };
        options.Matrix.TimeoutMilliseconds = lib.mkOption {
          type = lib.types.ints.positive;
          default = 45000;
          description = ''
            how long (in milliseconds) HTTP requests (from matrix-corporal to Matrix Synapse) are allowed to take before being timed out.
            Since clients often use long-polling for /sync (usually with a 30-second limit), setting this to a value of more than 30000 is recommended.
          '';
        };

        options.Reconciliation.UserId = lib.mkOption {
          type = lib.types.str;
          default = "@matrix-corporal:" + cfg.settings.Matrix.HomeserverDomainName;
          description = ''
            A full Matrix user id of the system (needs to have admin privileges), which will be used to perform reconciliation.
            This user account, with its admin privileges, will be used to find what users are available on the server, what their current state is, etc.
            This user account will also invite and kick users out of communities and rooms, so you need to make sure this user is joined to, and has the appropriate privileges, in all rooms and communities that you would like to manage.
          '';
        };
        options.Reconciliation.RetryIntervalMilliseconds = lib.mkOption {
          type = lib.types.ints.positive;
          default = 30000;
          description = ''
            How long (in milliseconds) to wait before retrying reconciliation, in case the previous reconciliation attempt failed (due to Matrix Synapse being down, etc.).
          '';
        };
        options.HttpGateway.ListenAddress = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1:41080";
          description = ''
            The network address to listen on.
            It's most likely a local one, as there's usually a reverse proxy (like nginx) capturing all traffic first and forwarding it here later on.
            If you're running this inside a container, use something like 0.0.0.0:41080.
          '';
        };
        options.HttpGateway.TimeoutMilliseconds = lib.mkOption {
          type = lib.types.addCheck lib.types.int (x: x >= cfg.Matrix.TimeoutMilliseconds);
          default = {};
          description = ''
            How long (in milliseconds) HTTP requests are allowed to take before being timed out.
            Since clients often use long-polling for /sync (usually with a 30-second limit), setting this to a value of more than 30000 is recommended.
            For this same reason, making this value larger than Matrix.TimeoutMilliseconds is required.
          '';
        };

        options.HttpApi.Enabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether the HTTP API is enabled or not";
        };
        options.HttpApi.ListenAddress = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1:41081";
          description = ''
            The network address to listen on.
            It's most likely a local one, as there's usually a reverse proxy (like nginx) capturing all traffic first and forwarding it here later on. If you're running this inside a container, use something like 0.0.0.0:41081.
          '';
        };

        options.PolicyProvider = {
          Type = lib.mkOption {
            type = lib.types.str;
            default = "static_file";
          };
        }

        options.Misc.Debug = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable debug mode or not (enable for more verbose logs)";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.matrix-corporal = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/matrix-corporal -c ${matrix-corporal-config}";
      };
    };
  };
}
