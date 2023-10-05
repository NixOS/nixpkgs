{ config, lib, pkgs, ... }:
let
  cfg = config.security.really;
in {
  options.security.really = {
    enable = lib.mkEnableOption "really";
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.really = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.really}/bin/really";
    };
  };
}
