{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    system.sbin.modprobe = mkOption {
      internal = true;
      default = pkgs.stdenv.mkDerivation {
        name = "modprobe";
        buildCommand = ''
          mkdir -p $out/bin
          for i in ${pkgs.kmod}/sbin/*; do
            name=$(basename $i)
            echo "$text" > $out/bin/$name
            echo 'exec '$i' "$@"' >> $out/bin/$name
            chmod +x $out/bin/$name
          done
          ln -s bin $out/sbin
        '';
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

          '';
        meta.priority = 4;
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

    environment.etc."modprobe.d/ubuntu.conf".source = "${pkgs.kmod-blacklist-ubuntu}/modprobe.conf";

    environment.etc."modprobe.d/nixos.conf".text =
      ''
        ${flip concatMapStrings config.boot.blacklistedKernelModules (name: ''
          blacklist ${name}
        '')}
        ${config.boot.extraModprobeConfig}
      '';
    environment.etc."modprobe.d/usb-load-ehci-first.conf".text =
      ''
        softdep uhci_hcd pre: ehci_hcd
        softdep ohci_hcd pre: ehci_hcd
      '';

    environment.systemPackages = [ config.system.sbin.modprobe pkgs.kmod ];

    system.activationScripts.modprobe =
      ''
        # Allow the kernel to find our wrapped modprobe (which searches
        # in the right location in the Nix store for kernel modules).
        # We need this when the kernel (or some module) auto-loads a
        # module.
        echo ${config.system.sbin.modprobe}/sbin/modprobe > /proc/sys/kernel/modprobe
      '';

    environment.sessionVariables.MODULE_DIR = "/run/current-system/kernel-modules/lib/modules";

  };

}
