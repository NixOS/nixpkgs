{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.shellhub-agent;
in {

  ###### interface

  options = {

    services.shellhub-agent = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the ShellHub Agent daemon, which allows
          secure remote logins.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.shellhub-agent;
        defaultText = "pkgs.shellhub-agent";
        description = ''
          Which ShellHub Agent package to use.
        '';
      };

      tenantId = mkOption {
        type = types.str;
        example = "ba0a880c-2ada-11eb-a35e-17266ef329d6";
        description = ''
          The tenant ID to use when connecting to the ShellHub
          Gateway.
        '';
      };

      server = mkOption {
        type = types.str;
        default = "https://cloud.shellhub.io";
        description = ''
          Server address of ShellHub Gateway to connect.
        '';
      };

      privateKey = mkOption {
        type = types.path;
        default = "/var/lib/shellhub-agent/private.key";
        description = ''
          Location where to store the ShellHub Agent private
          key.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

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

      environment.SERVER_ADDRESS = cfg.server;
      environment.PRIVATE_KEY = cfg.privateKey;
      environment.TENANT_ID = cfg.tenantId;

      serviceConfig = {
        # The service starts sessions for different users.
        User = "root";
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/agent";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
