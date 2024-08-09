{ config, lib, pkgs, ... }:

let
  cfg = config.programs.kdesu;

in
{
  options = {
    programs.kdesu = {
      enable = lib.mkEnableOption "kdesu with setuid wrapper";
      package.kdesu = lib.mkPackageOption pkgs.kdePackages "kdesu" {};
      package.kde-cli-tools = lib.mkPackageOption pkgs.kdePackages "kde-cli-tools" {};
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package.kde-cli-tools ];
    security.wrappers.kdesud = {
      setgid = true;
      owner = "root";
      group = "nogroup";
      source = "${cfg.package.kdesu}/libexec/kf6/kdesud";
    };
  };
}
