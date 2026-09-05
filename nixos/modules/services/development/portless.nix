{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.portless;
  # systemd StateDirectory = "portless" always resolves to /var/lib/portless
  stateDir = "/var/lib/portless";
in
{
  options.services.portless = {
    enable = lib.mkEnableOption "portless, a local HTTPS reverse proxy for development";

    package = lib.mkPackageOption pkgs "portless" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 443;
      description = ''
        Port for the HTTPS proxy to listen on.

        Ports below 1024 require `CAP_NET_BIND_SERVICE`, which this module
        grants automatically.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "portless";
      description = "User account under which the portless daemon runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "portless";
      description = ''
        Group under which the portless daemon runs.

        Add your user to this group to allow registering app routes with the
        running proxy:

        ```nix
        users.users.yourname.extraGroups = [ "portless" ];
        ```
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "portless") {
      portless = {
        isSystemUser = true;
        group = cfg.group;
        description = "Portless daemon user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "portless") {
      portless = { };
    };

    # Expose the state directory so that `portless run` in user shells finds
    # the running daemon without extra configuration.
    environment.variables.PORTLESS_STATE_DIR = stateDir;

    systemd.services.portless = {
      description = "Portless local HTTPS reverse proxy";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        # Creates /var/lib/portless owned by cfg.user:cfg.group.
        # Mode 0770 allows group members (developers) to register routes.
        StateDirectory = "portless";
        StateDirectoryMode = "0770";

        ExecStart = "${lib.getExe cfg.package} proxy start --foreground --port ${toString cfg.port}";

        Environment = [
          "PORTLESS_STATE_DIR=${stateDir}"
          # portless falls back to $HOME/.portless; point HOME at the state
          # directory so it never writes outside of it.
          "HOME=${stateDir}"
        ];

        # Grant the capability to bind to privileged ports when needed.
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];

        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ GuillaumeDesforges ];
}
