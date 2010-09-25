{config, pkgs, ...}:

{
  # Show the manual.
  services.nixosManual.showManual = true;

  # Let the user play Rogue on TTY 8 during the installation.
  services.rogue.enable = true;

  # Disable some other stuff we don't need.
  security.sudo.enable = false;

  # Include only the en_US locale.  This saves 75 MiB or so compared to
  # the full glibcLocales package.
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "en_US/ISO-8859-1"];

  # nixos-install will do a pull from this channel to speed up the
  # installation.
  installer.nixpkgsURL = http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable;

  boot.postBootCommands =
    ''
      # Provide a mount point for nixos-install.
      mkdir -p /mnt
    '';

  # Some more help text.
  services.mingetty.helpLine =
    ''
        
      Log in as "root" with an empty password.  ${
        if config.services.xserver.enable then
          "Type `start xserver' to start\nthe graphical user interface."
        else ""
      }
    '';


  # Allow sshd to be started manually through "start sshd".  It should
  # not be started by default on the installation CD because the
  # default root password is empty.
  services.openssh.enable = true;
  jobs.sshd.startOn = pkgs.lib.mkOverride 50 "";

  # Enable wpa_supplicant, but don't start it by default.
  networking.enableWLAN = true;
  jobs.wpa_supplicant.startOn = pkgs.lib.mkOverride 50 "";
}