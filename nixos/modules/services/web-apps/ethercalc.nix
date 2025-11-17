{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.ethercalc;
in
{
  options = {
    services.ethercalc = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          ethercalc, an online collaborative spreadsheet server.

          Persistent state will be maintained under
          {file}`/var/lib/ethercalc`. Upstream supports using a
          redis server for storage and recommends the redis backend for
          intensive use; however, the Nix module doesn't currently support
          redis.

          Note that while ethercalc is a good and robust project with an active
          issue tracker, there haven't been new commits since the end of 2020.
        '';
      };

      package = mkPackageOption pkgs "ethercalc" { };

      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "Address to listen on (use 0.0.0.0 to allow access from any address).";
      };

      port = mkOption {
        type = types.port;
        default = 8000;
        description = "Port to bind to.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ethercalc = {
      description = "Ethercalc service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/ethercalc --host ${cfg.host} --port ${toString cfg.port}";
        Restart = "always";
        StateDirectory = "ethercalc";
        WorkingDirectory = "/var/lib/ethercalc";
      };
    };
  };
}
