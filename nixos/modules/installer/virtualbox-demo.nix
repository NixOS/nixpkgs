{ lib, ... }:

with lib;

{
  imports =
    [ ../virtualisation/virtualbox-image.nix
      ../installer/cd-dvd/channel.nix
      ../profiles/demo.nix
      ../profiles/clone-config.nix
    ];

  # FIXME: UUID detection is currently broken
  boot.loader.grub.fsIdentifier = "provided";

  # Allow mounting of shared folders.
  users.users.demo.extraGroups = [ "vboxsf" ];

  # Add some more video drivers to give X11 a shot at working in
  # VMware and QEMU.
  services.xserver.videoDrivers = mkOverride 40 [ "virtualbox" "vmware" "cirrus" "vesa" "modesetting" ];

  powerManagement.enable = false;
  system.stateVersion = lib.mkDefault lib.trivial.release;

  installer.cloneConfigExtra = ''
  # Let demo build as a trusted user.
  # nix.settings.trusted-users = [ "demo" ];

  # Mount a VirtualBox shared folder.
  # This is configurable in the VirtualBox menu at
  # Machine / Settings / Shared Folders.
  # fileSystems."/mnt" = {
  #   fsType = "vboxsf";
  #   device = "nameofdevicetomount";
  #   options = [ "rw" ];
  # };

  # By default, the NixOS VirtualBox demo image includes SDDM and Plasma.
  # If you prefer another desktop manager or display manager, you may want
  # to disable the default.
  # services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  # services.displayManager.sddm.enable = lib.mkForce false;

  # Enable GDM/GNOME by uncommenting above two lines and two lines below.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # \$ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  '';
}
