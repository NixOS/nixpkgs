{ config, pkgs, ... }:

with pkgs.lib;

# blacklist "cirrusfb" "i2c_piix4"

{

  ###### interface

  options = {

    system.sbin.modprobe = mkOption {
      # should be moved in module-init-tools
      internal = true;
      default = pkgs.writeTextFile {
        name = "modprobe";
        destination = "/sbin/modprobe";
        executable = true;
        text =
          ''
            #! ${pkgs.stdenv.shell}
            export MODULE_DIR=${config.system.modulesTree}/lib/modules
            exec ${pkgs.module_init_tools}/sbin/modprobe "$@"
          '';
      };
      description = ''
        Wrapper around modprobe that sets the path to the modules
        tree.
      '';
    };

    boot.blacklistedKernelModules = mkOption {
      default = [];
      example = [ "cirrusfb" "i2c_piix4" ];
      description = ''
        List of names of kernel modules that should not be loaded
        automatically by the hardware probing code.
      '';
    };
  
    boot.extraModprobeConfig = mkOption {
      default = "";
      example =
        ''
          options parport_pc io=0x378 irq=7 dma=1
        '';
      description = ''
        Any additional configuration to be appended to the generated
        <filename>modprobe.conf</filename>.  This is typically used to
        specify module options.  See
        <citerefentry><refentrytitle>modprobe.conf</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };
  
  };


  ###### implementation

  config = {

    environment.etc = singleton
      { source = pkgs.writeText "modprobe.conf"
          ''
            ${flip concatMapStrings config.boot.blacklistedKernelModules (name: ''
              blacklist ${name}
            '')}
            ${config.boot.extraModprobeConfig}
          '';
        target = "modprobe.conf";
      };

    boot.blacklistedKernelModules =
      [ # This module is for debugging and generates gigantic amounts
        # of log output, so it should never be loaded automatically.
        "evbug"

        # !!! Hm, Ubuntu blacklists all framebuffer devices because
        # they're "buggy" and cause suspend problems.  Maybe we should
        # too?
      ];

  };

}
