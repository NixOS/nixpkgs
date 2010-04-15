{ config, pkgs, ... }:

let
  inherit (pkgs.lib) mkOption mkIf;

  cfg = config.environment.blcr;

  blcrPkg = config.boot.kernelPackages.blcr;

  insmod = "${pkgs.module_init_tools}/sbin/insmod";
  rmmod  = "${pkgs.module_init_tools}/sbin/rmmod";

  modulesDir      = "${blcrPkg}/lib/modules/${pkgs.linux.version}";
  blcr_imports_ko = "${modulesDir}/blcr_imports.ko";
  blcr_ko         = "${modulesDir}/blcr.ko";
in

{
  ###### interface

  options = {
    environment.blcr.enable = mkOption {
      default = false;
      description =
        "Wheter to enable support for the BLCR checkpoingint tool.";
    };

    environment.blcr.autorun = mkOption {
      default = true;
      description =
        "Whether to load BLCR kernel modules automatically at boot.";
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ blcrPkg ];

    jobs.blcr = {
        name        = "blcr";
        description = "Loads BLCR kernel modules";
	task        = true;

        startOn = if cfg.autorun then "started udev" else null;
        stopOn  = "shutdown";

	preStart = ''
          ${insmod} ${blcr_imports_ko}
          ${insmod} ${blcr_ko}
	'';
	postStop = ''
          ${rmmod} ${blcr_ko}
          ${rmmod} ${blcr_imports_ko}
	'';
      };
  };
}
