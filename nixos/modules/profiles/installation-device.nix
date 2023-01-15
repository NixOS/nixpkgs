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
    system.nixos.variant_id = lib.mkDefault "installer";

    # Enable in installer, even if the minimal profile disables it.
    documentation.enable = mkImageMediaOverride true;

    # Show the manual.
    documentation.nixos.enable = mkImageMediaOverride true;

    # Use less privileged nixos user
    users.users.nixos = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" ];
      # Allow the graphical user to login without password
      initialHashedPassword = "";
    };

    # Allow the user to log in as root without a password.
    users.users.root.initialHashedPassword = "";

    # Allow passwordless sudo from nixos user
    security.sudo = {
      enable = mkDefault true;
      wheelNeedsPassword = mkImageMediaOverride false;
    };

    # Automatically log in at the virtual consoles.
    services.getty.autologinUser = "nixos";

    # Some more help text.
    services.getty.helpLine = ''
      The "nixos" and "root" accounts have empty passwords.

      An ssh daemon is running. You then must set a password
      for either "root" or "nixos" with `passwd` or add an ssh key
      to /home/nixos/.ssh/authorized_keys be able to login.

      If you need a wireless connection, type
      `sudo systemctl start wpa_supplicant` and configure a
      network using `wpa_cli`. See the NixOS manual for details.
    '' + optionalString config.services.xserver.enable ''

      Type `sudo systemctl start display-manager' to
      start the graphical user interface.
    '';

    # We run sshd by default. Login via root is only possible after adding a
    # password via "passwd" or by adding a ssh key to /home/nixos/.ssh/authorized_keys.
    # The latter one is particular useful if keys are manually added to
    # installation device for head-less systems i.e. arm boards by manually
    # mounting the storage in a different system.
    services.openssh = {
      enable = true;
      permitRootLogin = "yes";
    };

    # Enable wpa_supplicant, but don't start it by default.
    networking.wireless.enable = mkDefault true;
    networking.wireless.userControlled.enable = true;
    systemd.services.wpa_supplicant.wantedBy = mkOverride 50 [];

    # Tell the Nix evaluator to garbage collect more aggressively.
    # This is desirable in memory-constrained environments that don't
    # (yet) have swap set up.
    environment.variables.GC_INITIAL_HEAP_SIZE = "1M";

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
        # For boot.initrd.systemd
        makeInitrdNGTool
        systemdStage1
        systemdStage1Network
      ] ++ (
        # also include a copy of the manual built from a minimal config.
        # the manual included by the installer is not sufficient alone
        # because it contains options the installed system will likely
        # not have (since it won't import the installer modules), so
        # we need the second copy to avoid manual builds during install.
        let
          manual = (import "${pkgs.path}/nixos" {
            configuration = {
              boot.isContainer = true;
              documentation.enable = true;
              documentation.nixos.enable = true;
            };
          }).config.system.build.manual;
        in [
          manual.generatedSources
          manual.optionsJSON
          manual.optionsDocBook
          manual.manpages
          manual.manualHTML
        ]
      );

    # Show all debug messages from the kernel but don't log refused packets
    # because we have the firewall enabled. This makes installs from the
    # console less cumbersome if the machine has a public IP.
    networking.firewall.logRefusedConnections = mkDefault false;

    # Prevent installation media from evacuating persistent storage, as their
    # var directory is not persistent and it would thus result in deletion of
    # those entries.
    environment.etc."systemd/pstore.conf".text = ''
      [PStore]
      Unlink=no
    '';
  };
}
