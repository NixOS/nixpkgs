# Provide a basic configuration for installation devices like CDs.
{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

{
  imports = [
    # Enable devices which are usually scanned, because we don't know the
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
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
      ];
      # Allow the graphical user to login without password
      initialHashedPassword = "";
    };

    # Allow the user to log in as root without a password.
    users.users.root.initialHashedPassword = "";

    # Don't require sudo/root to `reboot` or `poweroff`.
    security.polkit.enable = true;

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

      To log in over ssh you must set a password for either "nixos" or "root"
      with `passwd` (prefix with `sudo` for "root"), or add your public key to
      /home/nixos/.ssh/authorized_keys or /root/.ssh/authorized_keys.

      To set up a wireless connection, run `nmtui`.
    ''
    + optionalString config.services.xserver.enable ''

      Type `sudo systemctl start display-manager' to
      start the graphical user interface.
    '';

    # We run sshd by default. Login is only possible after adding a
    # password via "passwd" or by adding a ssh key to ~/.ssh/authorized_keys.
    # The latter one is particular useful if keys are manually added to
    # installation device for head-less systems i.e. arm boards by manually
    # mounting the storage in a different system.
    services.openssh = {
      enable = mkDefault true;
      settings.PermitRootLogin = mkDefault "yes";
    };

    # Provide networkmanager for easy network configuration.
    networking.networkmanager.enable = true;

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
    # stdenvNoCC in the Nix store on the CD.
    system.extraDependencies =
      with pkgs;
      [
        stdenvNoCC # for runCommand
        busybox
        # For boot.initrd.systemd
        makeInitrdNGTool
      ]
      ++ jq.all; # for closureInfo

    boot.swraid.enable = true;
    # remove warning about unset mail
    boot.swraid.mdadmConf = "PROGRAM ${pkgs.coreutils}/bin/true";

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

    # allow nix-copy to live system
    nix.settings.trusted-users = [ "nixos" ];

    # Provide rsync by default
    environment.defaultPackages = with pkgs; [
      rsync
    ];

    # Provide git by default
    programs.git.enable = lib.mkDefault true;

    # Set a default stateVersion to prevent evaluation warnings
    system.stateVersion = lib.mkDefault lib.trivial.release;

    # Install fewer voices for speechd to save some space
    nixpkgs.overlays = [
      (_: prev: {
        mbrola-voices = prev.mbrola-voices.override {
          # only ship with one voice per language
          languages = [ "*1" ];
        };
      })
    ];
  };
}
