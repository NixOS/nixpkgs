{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.${moduleName};
  moduleName = "linuxcnc";
in
{
  meta.maintainers = with lib.maintainers; [ wucke13 ];

  options.programs.${moduleName} = {

    enable = lib.options.mkEnableOption moduleName;

    package =
      (lib.options.mkPackageOption pkgs "linuxcnc" {
        default = [ "linuxcnc" ];
      })
      // {
        apply = p: p.override { enableSetuidWrapperRedirection = true; };
      };

  };

  config = lib.mkIf cfg.enable {
    # create wrapper with setuid bit set
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

    # Make all LinuxCNC programs and required tools available
    environment.systemPackages = [
      cfg.package
      pkgs.iptables
    ];
  };
}
