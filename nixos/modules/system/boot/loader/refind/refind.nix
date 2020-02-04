{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.loader.refind;

  efi = config.boot.loader.efi;

  refindBuilder = pkgs.substituteAll {
    src = ./refind-builder.py;

    isExecutable = true;

    inherit (pkgs) python3;

    nix = config.nix.package.out;

    timeout = if config.boot.loader.timeout != null then config.boot.loader.timeout else "";

    extraConfig = cfg.extraConfig;

    extras = if cfg.extras != null then cfg.extras else "";

    installAsRemovable = cfg.installAsRemovable;

    inherit (pkgs) refind efibootmgr coreutils gnugrep gnused gawk utillinux;

    inherit (efi) efiSysMountPoint canTouchEfiVariables;
  };

in {

  options.boot.loader.refind = {
    enable = mkOption {
      description = "Whether to enable the refind EFI boot manager";
      type = types.bool;
      default = false;
    };

    installAsRemovable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Unless you turn this on, rEFInd will install itself in
        <literal>boot.loader.efi.efiSysMountPoint</literal> (namely
        <literal>EFI/refind/refind_$arch.efi</literal>)
        If you've set <literal>boot.loader.efi.canTouchEfiVariables</literal>
        *AND* you are currently booted in UEFI mode, then rEFInd will use
        <literal>efibootmgr</literal> to modify the boot order in the
        EFI variables of your firmware to include this location. If you are
        *not* booted in UEFI mode at the time rEFInd is being installed, the
        NVRAM will not be modified, and your system will not find rEFInd at
        boot time. However, rEFInd will still return success so you may miss
        the warning that gets printed ("<literal>efibootmgr: EFI variables
        are not supported on this system.</literal>").</para>

        <para>If you turn this feature on, rEFInd will install itself in a
        special location within <literal>efiSysMountPoint</literal> (namely
        <literal>EFI/boot/boot$arch.efi</literal>) which the firmwares
        are hardcoded to try first, regardless of NVRAM EFI variables.</para>

        <para>To summarize, turn this on if:
        <itemizedlist>
          <listitem><para>You are installing NixOS and want it to boot in UEFI mode,
          but you are currently booted in legacy mode</para></listitem>
          <listitem><para>You want to make a drive that will boot regardless of
          the NVRAM state of the computer (like a USB "removable" drive)</para></listitem>
          <listitem><para>You simply dislike the idea of depending on NVRAM
          state to make your drive bootable</para></listitem>
        </itemizedlist>
      '';
    };

    extraConfig = mkOption {
      description = "Extra configuration text appended to refind.conf";
      type = types.lines;
      default = "";
    };

    extras = mkOption {
      description = "Extra content to be copied to extras-directory.";
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.boot.kernelPackages.kernel.features.efiBootStub or true;
        message = "This kernel does not support the EFI boot stub";
      }
    ];

    boot.loader.grub.enable = mkDefault false;

    boot.loader.supportsInitrdSecrets = false; # TODO what does this do ?

    system = {
      build.installBootLoader = refindBuilder;

      boot.loader.id = "refind";

      requiredKernelConfig = with config.lib.kernelConfig; [
        (isYes "EFI_STUB")
      ];
    };
  };

}
