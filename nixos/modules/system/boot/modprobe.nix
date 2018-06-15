{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

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
    environment.etc."modprobe.d/debian.conf".source = pkgs.kmod-debian-aliases;

    environment.systemPackages = [ pkgs.kmod ];

    system.activationScripts.modprobe = stringAfter ["specialfs"]
      ''
        # Allow the kernel to find our wrapped modprobe (which searches
        # in the right location in the Nix store for kernel modules).
        # We need this when the kernel (or some module) auto-loads a
        # module.
        echo ${pkgs.kmod}/bin/modprobe > /proc/sys/kernel/modprobe
      '';

  };

}
