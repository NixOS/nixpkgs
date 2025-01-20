{ config, pkgs, lib, ... }:

let cfg = config.programs.yottadb;
in {
  options.programs.yottadb = {
    enable = lib.mkEnableOption "YottaDB";

    package =
      lib.mkPackageOption pkgs "YottaDB" { default = [ "yottadb.latest" ]; };
  };

  config = let package = cfg.package;
  in lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    systemd.tmpfiles.packages = [ package ];
  };
}
