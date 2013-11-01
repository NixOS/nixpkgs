{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.programs.gurobi;
in {
  options = {
    programs.gurobi = {
      license = mkOption {
        default = null;

        description = "Path to the Gurobi license file if not using a token server";

        type = types.nullOr types.path;
      };

      tokenServerAddress = mkOption {
        default = null;

        description = "Address of the token server";

        type = types.nullOr types.string;
      };
    };
  };

  config = mkIf (cfg.license != null || cfg.tokenServerAddress != null) {
    assertions = [ {
      assertion = cfg.license == null || cfg.tokenServerAddress == null;
      message = "Please only set one of a gurobi license file and a gurobi token server address";
    } ];

    environment.variables.GRB_LICENSE_FILE = if cfg.license != null
      then cfg.license
      else pkgs.writeTextFile {
        name = "gurobi-generated-license";
        text = "TOKENSERVER=${cfg.tokenServerAddress}";
      };

    environment.systemPackages = [ pkgs.gurobi ];
  };
}
