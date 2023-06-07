{ config, lib, pkgs, ... }:

let
  cfg = config.programs.darling;
in {
  options = {
    programs.darling = {
      enable = lib.mkEnableOption (lib.mdDoc "Darling, a Darwin/macOS compatibility layer for Linux");
      package = lib.mkPackageOptionMD pkgs "darling" {};
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.darling = {
      source = lib.getExe cfg.package;
      owner = "root";
      group = "root";
      setuid = true;
    };
  };
}
