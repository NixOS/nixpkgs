{
  config,
  pkgs,
  lib,
  ...
}:

{

  config = lib.mkIf config.boot.isContainer {

    # Disable some features that are not useful in a container.

    # containers don't have a kernel
    boot.kernel.enable = false;
    boot.modprobeConfig.enable = false;

    console.enable = lib.mkDefault false;

    nix.optimise.automatic = lib.mkDefault false; # the store is host managed
    powerManagement.enable = lib.mkDefault false;
    documentation.nixos.enable = lib.mkDefault false;

    networking.useHostResolvConf = lib.mkDefault true;

    # Containers should be light-weight, so start sshd on demand.
    services.openssh.startWhenNeeded = lib.mkDefault true;

    # containers do not need to setup devices
    services.udev.enable = false;

    # containers normally do not need to manage logical volumes
    services.lvm.enable = lib.mkDefault false;

    # Shut up warnings about not having a boot loader.
    system.build.installBootLoader = lib.mkDefault "${pkgs.coreutils}/bin/true";

    # Not supported in systemd-nspawn containers.
    security.audit.enable = false;

    # Use the host's nix-daemon.
    environment.variables.NIX_REMOTE = "daemon";

  };

}
