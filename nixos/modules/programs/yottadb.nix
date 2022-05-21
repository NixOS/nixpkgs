{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.programs.yottadb;
in {
  options.programs.yottadb = {
    enable = mkEnableOption "YottaDB";

    package = mkPackageOption pkgs "YottaDB" {
      default = [ "yottadb" ];
    };
  };

  config =
    let
      package = cfg.package;
    in
    mkIf cfg.enable {
      environment.systemPackages = [ package ];
      security.wrappers."${package.gtmsecshrSuidName}" = {
        setuid = true;
        owner = "root";
        group = "${package.ydbGroup}";
        permissions = "u+rx";
        source = "${package}/${package.gtmsecshrSuidTargetRelative}";
      };
      security.wrappers."${package.gtmsecshrWrapperSuidName}" = {
        setuid = true;
        owner = "root";
        group = "${package.ydbGroup}";
        permissions = "a+rx";
        source = "${package}/${package.gtmsecshrWrapperSuidTargetRelative}";
      };
    };
}
