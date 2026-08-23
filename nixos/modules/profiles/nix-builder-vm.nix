/*
  This profile uses NixOS to create a remote builder VM to build Linux packages,
  which can be used to build packages for Linux on other operating systems;
  primarily macOS.

  It combines the backend-neutral remote-builder profile (./nix-builder.nix)
  with the QEMU VM backend (../virtualisation/qemu-vm.nix), which provides the
  `config.system.build.vm` runner that the installer script launches.
*/
{ config, ... }:

{
  imports = [
    ./nix-builder.nix
    ../virtualisation/qemu-vm.nix
  ];

  config = {
    # DNS fails for QEMU user networking (SLiRP) on macOS.  See:
    #
    # https://github.com/utmapp/UTM/issues/2353
    #
    # This works around that by using a public DNS server other than the DNS
    # server that QEMU provides (normally 10.0.2.3)
    networking.nameservers = [ "8.8.8.8" ];

    virtualisation = {
      forwardPorts = [
        {
          from = "host";
          guest.port = 22;
          host.port = config.virtualisation.darwin-builder.hostPort;
        }
      ];

      # Disable graphics for the builder since users will likely want to run it
      # non-interactively in the background.
      graphics = false;

      # If we don't enable this option then the host will fail to delegate builds
      # to the guest, because:
      #
      # - The host will lock the path to build
      # - The host will delegate the build to the guest
      # - The guest will attempt to lock the same path and fail because
      #   the lockfile on the host is visible on the guest
      #
      # Snapshotting the host's /nix/store as an image isolates the guest VM's
      # /nix/store from the host's /nix/store, preventing this problem.
      useNixStoreImage = true;
    };
  };
}
