{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    system.sbin.modprobe = mkOption {
      internal = true;
      default = pkgs.writeTextFile {
        name = "modprobe";
        destination = "/sbin/modprobe";
        executable = true;
        text =
          ''
            #! ${pkgs.stdenv.shell}
            export MODULE_DIR=/run/current-system/kernel-modules/lib/modules

            # Fall back to the kernel modules used at boot time if the
            # modules in the current configuration don't match the
            # running kernel.
            if [ ! -d "$MODULE_DIR/$(${pkgs.coreutils}/bin/uname -r)" ]; then
                MODULE_DIR=/run/booted-system/kernel-modules/lib/modules/
            fi

            exec ${pkgs.kmod}/sbin/modprobe "$@"
          '';
      };
      description = ''
        Wrapper around modprobe that sets the path to the modules
        tree.
      '';
    };

    boot.blacklistedKernelModules = mkOption {
      type = types.listOf types.str;
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
      type = types.lines;
    };

  };


  ###### implementation

  config = mkIf (!config.boot.isContainer) {

    environment.etc = singleton
      { source = pkgs.writeText "modprobe.conf"
          ''
            ${flip concatMapStrings config.boot.blacklistedKernelModules (name: ''
              blacklist ${name}
            '')}
            ${config.boot.extraModprobeConfig}
          '';
        target = "modprobe.d/nixos.conf";
      };

    environment.systemPackages = [ config.system.sbin.modprobe pkgs.kmod ];

    boot.blacklistedKernelModules =
      [ # This module is for debugging and generates gigantic amounts
        # of log output, so it should never be loaded automatically.
        "evbug"

        # This module causes ALSA to occassionally select the wrong
        # default sound device, and is little more than an annoyance
        # on modern machines.
        "snd_pcsp"

        # The cirrusfb module prevents X11 from starting.  FIXME:
        # Ubuntu blacklists all framebuffer devices because they're
        # "buggy" and cause suspend problems.  Maybe we should too?
        "cirrusfb"
      ];

    system.activationScripts.modprobe =
      ''
        # Allow the kernel to find our wrapped modprobe (which searches
        # in the right location in the Nix store for kernel modules).
        # We need this when the kernel (or some module) auto-loads a
        # module.
        echo ${config.system.sbin.modprobe}/sbin/modprobe > /proc/sys/kernel/modprobe
      '';

    environment.variables.MODULE_DIR = "/run/current-system/kernel-modules/lib/modules";

  };

}
