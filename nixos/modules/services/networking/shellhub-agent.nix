{ config, lib, pkgs, ... }:

let
  cfg = config.services.shellhub-agent;
in
{
  ###### interface

  options = {

    services.shellhub-agent = {

      enable = lib.mkEnableOption "ShellHub Agent daemon";

      package = lib.mkPackageOption pkgs "shellhub-agent" { };

      preferredHostname = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Set the device preferred hostname. This provides a hint to
          the server to use this as hostname if it is available.
        '';
      };

      keepAliveInterval = lib.mkOption {
        type = lib.types.int;
        default = 30;
        description = ''
          Determine the interval to send the keep alive message to
          the server. This has a direct impact of the bandwidth
          used by the device.
        '';
      };

      tenantId = lib.mkOption {
        type = lib.types.str;
        example = "ba0a880c-2ada-11eb-a35e-17266ef329d6";
        description = ''
          The tenant ID to use when connecting to the ShellHub
          Gateway.
        '';
      };

      server = lib.mkOption {
        type = lib.types.str;
        default = "https://cloud.shellhub.io";
        description = ''
          Server address of ShellHub Gateway to connect.
        '';
      };

      privateKey = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/shellhub-agent/private.key";
        description = ''
          Location where to store the ShellHub Agent private
          key.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.services.shellhub-agent = {
      description = "ShellHub Agent";

      wantedBy = [ "multi-user.target" ];
      requires = [ "local-fs.target" ];
      wants = [ "network-online.target" ];
      after = [
        "local-fs.target"
        "network.target"
        "network-online.target"
        "time-sync.target"
      ];

      environment = {
        SHELLHUB_SERVER_ADDRESS = cfg.server;
        SHELLHUB_PRIVATE_KEY = cfg.privateKey;
        SHELLHUB_TENANT_ID = cfg.tenantId;
        SHELLHUB_KEEPALIVE_INTERVAL = toString cfg.keepAliveInterval;
        SHELLHUB_PREFERRED_HOSTNAME = cfg.preferredHostname;
      };

      serviceConfig = {
        # The service starts sessions for different users.
        User = "root";
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/agent";
      };
    };
  };
}

