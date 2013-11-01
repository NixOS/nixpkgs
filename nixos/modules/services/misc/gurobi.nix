{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.gurobi.tokenServer;
in {
  options = {
    services.gurobi.tokenServer = {
      enable = mkOption {
        default = false;

        description = "Whether to enable the Gurobi token server";

        type = types.bool;
      };

      license = mkOption {
        description = "Path to the Gurobi license file";

        type = types.path;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.gurobi-token-server = {
      description = "Gurobi token server";

      wantedBy = [ "multi-user.target" ];

      environment.GRB_LICENSE_FILE = cfg.license;

      serviceConfig = {
        ExecStart = "${pkgs.gurobi}/bin/grb_ts";

        Type = "forking";
      };
    };
  };
}
