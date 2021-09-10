{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.maven;
in {
  options = {
    programs.maven = {
      enable = mkEnableOption "maven";

      package = mkOption {
        type = types.path;
        description = "The maven package version";
        default = pkgs.maven;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];

      variables = rec {
        M2 = "${M2_HOME}/bin";
        M2_HOME = "${cfg.package}/maven";
      };
    };
  };
}
