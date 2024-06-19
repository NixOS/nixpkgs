{ config, lib, pkgs, utils, ... }:
with lib;
let
  # NB: build the manual with:
  # $ nix-build nixos/release.nix -A manual.x86_64-linux

  # NB: run the tests with:
  # $ nix-build -A nixosTests.iroh

  # Docs for writing tests:
  # https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests

  # TODO test: configure systemd logs directory:
  # iroh: Failed to create log directory: Read-only filesystem

  # TODO run systemd-analyze security and apply whatever sandboxing doesn't break the service
  # TODO add tests

  # cfg is a conventional alias for the configuration of the current module
  cfg = config.services.iroh;

  # Default listening port.
  listenPort = 11204;
  # Default RPC port.
  rpcPort = 1337;
  # Default metrics port. With a value of -1 serving metrics is disabled.
  metricsPort = -1;

  # --add <ADD>: optionally add a file or folder to the node
  irohFlags = utils.escapeSystemdExecArgs (
    optional (cfg.metricsPort != -1) "--metrics-port ${cfg.metricsPort}" ++
    optional cfg.noTicket "--no-ticket" ++
    optional (cfg.tag != null) "--tag ${cfg.tag}" ++
    cfg.extraFlags
  );

  # A submodule that describes a relay node used to assist in NAT traversal.
  relayNode = types.submodule {
    options = {
      # TODO use regex to match URL, including https:// prefix!
      url = mkOption {
        description = "The URL of the relay node.";
        type = types.str;
      };

      stunOnly = mkOption {
        description = "Only use STUN for traversal of NAT gateways.";
        type = types.bool;
      };

      stunPort = mkOption {
        description = "Port at which STUN service is listening.";
        type = types.port;
      };
    };
  };

  # The total set of relays is the merge of relayNodes (which are the default nodes provided by
  # iroh, if not replaced) and any extra nodes defined by the user.
  relaySettings = cfg.relayNodes // cfg.extraRelayNodes;

  # The config file should be located in the data directory and is NOT created by default. All
  # values are optional, including the file itself.
  configFormat = pkgs.formats.toml { };
  #configFile = configFormat.generate "${cfg.dataDir}/iroh.config.toml" relaySettings;
  configFile = configFormat.generate "/var/lib/iroh/iroh.config.toml" relaySettings;
in
{
  # A NixOS module is a function that takes an environment and returns an attrset with the imports,
  # options, and config fields. The provided parameters include:
  # - config: an attrset with all the values of the configuration options
  # - pkgs: all the packages defined in nixpkgs
  # - lib: the utility library that comes with nixpkgs; it's commonly required so it is imported
  #   using 'with lib'
  # - other fields not usually needed by user modules

  # A list of other modules to import. Only necessary if the imported module isn't already in
  # module-list.nix, e.g. when writing several related modules, where only one of them is added to
  # the global module list. When using "imports' the arguments to the current module (config, lib,
  # pkgs) will also be passed to the submodules.
  imports = [
    #./other-module.nix
  ];

  # Option declarations for our module.
  options = {
    services.iroh = {

      # By convention, modules have an "enable" option that determines whether they are active or
      # not.
      enable = mkEnableOption ''Iroh is a protocol for syncing bytes. Bytes of any size, across any
        number of devices. Use iroh to create apps that scale different.
      '';

      package = mkPackageOption pkgs "iroh" { };

      listenPort = mkOption {
        description = "Address iroh listens on for connections from other nodes. If the port is taken iroh will choose a random port to listen on. This port is NOT automatically opened in the firewall.";
        type = types.port;
        default = listenPort;
      };

      rpcPort = mkOption {
        description = "Port for localhost-only Remote Procedure Calls, used to control an iroh node from another process. If the port is taken iroh will fail to start.";
        type = types.port;
        default = rpcPort;
      };

      metricsPort = mkOption {
        description = "Port at which metrics data is served. By default it is not enabled. Value must be -1 to disable serving metrics, or a valid port number.";
        type = types.either ( types.ints.between (-1) (-1) ) types.port;
        default = metricsPort;
      };

      noTicket = mkOption {
        description = "Do not print the all-in-one ticket to get the data from this node.";
        type = types.bool;
        default = false;
      };

      tag = mkOption {
        description = "An optional tag to apply to hosted data.";
        type = types.nullOr types.str;
        default = null;
      };

      user = mkOption {
        type = types.str;
        default = "iroh";
        description = "User under which the Iroh daemon runs.";
      };

      group = mkOption {
        type = types.str;
        default = "iroh";
        description = "Group under which the Iroh daemon runs.";
      };

      # TODO can we get rid of this when running with a systemd StateDir? Perhaps we only want it as
      # a place to put our generated config file, when that's necessary?
      # dataDir = mkOption {
      #   type = types.path;
      #   default = "/var/lib/iroh";
      #   description = ''The data directory for iroh.

      #     If the IROH_DATA_DIR environment variable is set, all other values will be
      #     ignored in favour of IROH_DATA_DIR. If the directory path does not exist, iroh will attempt to
      #     create all directories in the path string (similar to mkdir -p on Unix systems), failing if
      #     the final path cannot be written to.
      #   '';
      # };

      extraFlags = mkOption {
        type = types.listOf types.str;
        description = "Extra flags passed to the Iroh daemon";
        default = [ ];
      };

      relayNodes = mkOption {
        description = "Nodes used to assist in holepunching when NAT traversal fails. If configured, these nodes replace the default set of relay nodes.";
        type = types.listOf relayNode;
        default = [
          {
            url = "https//use1-1.derp.iroh.network.";
            stunOnly = false;
            stunPort = 3478;
          }
          {
            url = "https//euw1-1.derp.iroh.network.";
            stunOnly = false;
            stunPort = 3478;
          }
        ];
      };

      extraRelayNodes = mkOption {
        description = "Nodes used to assist in holepunching. If configured, any nodes are added to the default set of relay nodes.";
        type = types.listOf relayNode;
        default = [ ];
      };

    };
  };

  # Generate the actual configuration produced by this module.
  #
  # NB: The iroh CLI loads configuration from a iroh.config.toml file within the data directory. The
  # file is in TOML format, and all values are optional, including the file itself. Iroh does not
  # create iroh.config.toml by default.
  #
  # Here's the default configuration for relay nodes:
  #
  # [[relay_nodes]]
  # url = "https://use1-1.derp.iroh.network."
  # stun_only = false
  # stun_port = 3478
  #
  # [[relay_nodes]]
  # url = "https://euw1-1.derp.iroh.network."
  # stun_only = false
  # stun_port = 3478

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.rpcPort != null;
        message = ''
          The RPC port must be specified.
        '';
      }
    ];

    # TODO If we need to have a static user/group, look here:
    # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/misc/ids.nix

    # Create a user to run the service.
    # users.users = mkIf (cfg.user == "iroh") {
    #   iroh = {
    #     group = cfg.group;
    #     home = cfg.dataDir;
    #     createHome = false;
    #     uid = config.ids.uids.iroh;
    #     description = "Iroh daemon user";
    #     packages = [ ];
    #   };
    # };

    # users.groups = mkIf (cfg.group == "iroh") {
    #   iroh.gid = config.ids.gids.iroh;
    # };

    # Run iroh with a systemd "dynamic user":
    # https://0pointer.net/blog/dynamic-users-with-systemd.html

    # Define the systemd service.
    systemd.services.iroh = {
      after = [ "network-online.target" ];

      path = [ "/run/wrappers" pkgs.iroh ];

      #environment.IROH_DATA_DIR = cfg.dataDir;

      # preStart
      # postStop

      # NB: we don't start in the background with --start because defining a systemd service.
      serviceConfig = {
        ExecStart = [ "" "${cfg.package}/bin/iroh start ${irohFlags}" ];

        #User = cfg.user;
        #Group = cfg.group;

        DynamicUser = true;
        # /var/lib/iroh -> /var/lib/private/iroh
        StateDirectory = "iroh";
        # /var/log/iroh -> /var/log/private/iroh
        LogsDirectory = "iroh";

        #CacheDirectory = "";
        #ReadWritePaths = cfg.dataDir;

        # # Make sure the socket units are started before ipfs.service
        # Sockets = [ "ipfs-gateway.socket" "ipfs-api.socket" ];
        #Restart = "on-failure";
        #RestartSec = "5s";
      };

    };

    #other.opts.go.here = true;

    # meta = {
    #   maintainers = with lib.maintainers; [ Luflosi ];
    # };

  };
}
