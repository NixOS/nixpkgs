# Provide a basic configuration for installation devices like CDs.
{ config, pkgs, lib, ... }:

with lib;

{
  imports =
    [ # Enable devices which are usually scanned, because we don't know the
      # target system.
      ../installer/scan/detected.nix
      ../installer/scan/not-detected.nix

      # Allow "nixos-rebuild" to work properly by providing
      # /etc/nixos/configuration.nix.
      ./clone-config.nix

      # Include a copy of Nixpkgs so that nixos-install works out of
      # the box.
      ../installer/cd-dvd/channel.nix
    ];

  config = {

    # Enable in installer, even if the minimal profile disables it.
    services.nixosManual.enable = mkForce true;

    # Show the manual.
    services.nixosManual.showManual = true;

    # Let the user play Rogue on TTY 8 during the installation.
    #services.rogue.enable = true;

    # Disable some other stuff we don't need.
    security.sudo.enable = false;

    # Automatically log in at the virtual consoles.
    services.mingetty.autologinUser = "root";

    # Some more help text.
    services.mingetty.helpLine =
      ''

        The "root" account has an empty password.  ${
          optionalString config.services.xserver.enable
            "Type `systemctl start display-manager' to\nstart the graphical user interface."}
      '';

    # Allow sshd to be started manually through "systemctl start sshd".
    services.openssh = {
      enable = true;
      # Allow password login to the installation, if the user sets a password via "passwd"
      # It is safe as root doesn't have a password by default and SSH is disabled by default
      permitRootLogin = "yes";
    };
    systemd.services.sshd.wantedBy = mkOverride 50 [];

    # Enable wpa_supplicant, but don't start it by default.
    networking.wireless.enable = mkDefault true;
    systemd.services.wpa_supplicant.wantedBy = mkOverride 50 [];

    # Tell the Nix evaluator to garbage collect more aggressively.
    # This is desirable in memory-constrained environments that don't
    # (yet) have swap set up.
    environment.variables.GC_INITIAL_HEAP_SIZE = "100000";

    # Make the installer more likely to succeed in low memory
    # environments.  The kernel's overcommit heustistics bite us
    # fairly often, preventing processes such as nix-worker or
    # download-using-manifests.pl from forking even if there is
    # plenty of free memory.
    boot.kernel.sysctl."vm.overcommit_memory" = "1";

    # To speed up installation a little bit, include the complete
    # stdenv in the Nix store on the CD.
    system.extraDependencies = with pkgs;
      [
        stdenv
        stdenvNoCC # for runCommand
        busybox
        jq # for closureInfo
      ];

    # Show all debug messages from the kernel but don't log refused packets
    # because we have the firewall enabled. This makes installs from the
    # console less cumbersome if the machine has a public IP.
    networking.firewall.logRefusedConnections = mkDefault false;

    environment.systemPackages = [ pkgs.vim ];
  };
}
