{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.linuxcnc;
in
{
  meta.maintainers = with lib.maintainers; [ wucke13 ];

  options.programs.linuxcnc = {

    enable = lib.options.mkEnableOption "linuxcnc";

    package = (lib.options.mkPackageOption pkgs "linuxcnc" { }) // {
      apply = p: p.override { enableSetuidWrapperRedirection = true; };
    };

  };

  config = lib.mkIf cfg.enable {
    security.wrappers = lib.mkIf cfg.enable (
      lib.attrsets.genAttrs' cfg.package.setuidApps (program: {
        name = "linuxcnc-${program}";
        value = {
          owner = "root";
          group = "root";
          inherit program;
          setuid = true;
          source = lib.meta.getExe' cfg.package "${program}-nosetuid";
        };
      })
    );

    environment.systemPackages = [
      cfg.package
      pkgs.iptables
    ];
  };
}
