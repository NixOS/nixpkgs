{ lib, pkgs, config, ... }:
let
  cfg = config.services.matrix-corporal;
  format = pkgs.formats.json {};
  matrix-corporal-config = format.generate "matrix-corporal-config.json" cfg.settings;
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
      type = lib.types.submodule {
        freeformType = format.type;

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
        options.Reconciliation.UserId = lib.mkOption {
          type = lib.types.str;
          default = "@matrix-corporal:" + cfg.settings.Matrix.HomeserverDomainName;
          description = ''
            A full Matrix user id of the system (needs to have admin privileges), which will be used to perform reconciliation.
            This user account, with its admin privileges, will be used to find what users are available on the server, what their current state is, etc.
            This user account will also invite and kick users out of communities and rooms, so you need to make sure this user is joined to, and has the appropriate privileges, in all rooms and communities that you would like to manage.
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
        options.PolicyProvider = lib.mkOption {
          type = lib.types.attrs;
          default = {
            Type = "static_file";
            Path = "/etc/matrix-corporal/policy.json";
          };
          description = "The policy provider, see <link xlink:href="https://github.com/devture/matrix-corporal/blob/e8250a98292ae250726ce5edd75bc6ece4eb5115/docs/policy-providers.md"/> for supported values";
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.matrix-corporal.settings = {
      Matrix.TimeoutMilliseconds = lib.mkDefault 45000;
      Reconciliation.RetryIntervalMilliseconds = lib.mkDefault 30000;
      HttpGateway.TimeoutMilliseconds = lib.mkDefault cfg.settings.Matrix.TimeoutMilliseconds;
      HttpApi.TimeoutMilliseconds = lib.mkDefault 15000;
    };

    systemd.services.matrix-corporal = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/devture-matrix-corporal -config ${matrix-corporal-config}";
      };
    };
  };
}
