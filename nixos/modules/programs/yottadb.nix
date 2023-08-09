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

      # boot.specialFileSystems.${package.ydbSecRunDir} = {
      #   fsType = "tmpfs";
      #   options = [ "nodev" "mode=755" "size=32M" ];
      # };

      systemd.tmpfiles.rules = [
        # Create `gtmsrcshrdir` with the right permissions and ownership
        "d  ${package.ydbSecRunDir}/gtmsecshrdir 0500 root root"

        # Copy `gtmsecshr` binary and set the right permissions and ownership
        "C+ ${package.ydbSecRunDir}/gtmsecshrdir/gtmsecshr - - - - ${package}/dist/gtmsecshr-real"
        "z  ${package.ydbSecRunDir}/gtmsecshrdir/gtmsecshr 4500 root root"

        # Copy `gtmsecshr` *wrapper* binary and set the right permissions and ownership
        "C+ ${package.ydbSecRunDir}/gtmsecshr - - - - ${package}/dist/gtmsecshr-wrap"
        "z  ${package.ydbSecRunDir}/gtmsecshr 4555 root root"
      ];
    };
}
