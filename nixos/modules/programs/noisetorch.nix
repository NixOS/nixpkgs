{ config, pkgs, lib, ... }:

with lib;

let cfg = config.programs.noisetorch;
in {
  options.programs.noisetorch = {
    enable = mkEnableOption "noisetorch + setcap wrapper";

    package = mkOption {
      type = types.package;
      default = pkgs.noisetorch;
      description = ''
        The noisetorch package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.noisetorch = {
      source = "${cfg.package}/bin/noisetorch";
      capabilities = "cap_sys_resource=+ep";
    };
  };
}
