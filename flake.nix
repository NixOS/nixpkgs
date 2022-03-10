# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let
      jobs = import ./pkgs/top-level/release.nix {
        nixpkgs = self;
      };

      lib = import ./lib;

      systems = lib.systems.supported.hydra;

      forAllSystems = f: lib.genAttrs systems (system: f system);

    in
    {
      lib = lib.extend (final: prev: {

        nixos = import ./nixos/lib { lib = final; };

        nixosSystem = args:
          import ./nixos/lib/eval-config.nix (args // {
            modules = args.modules ++ [ {
              system.nixos.versionSuffix =
                ".${final.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101")}.${self.shortRev or "dirty"}";
              system.nixos.revision = final.mkIf (self ? rev) self.rev;
            } ];
          });
      });

      checks.x86_64-linux.tarball = jobs.tarball;

      htmlDocs = {
        nixpkgsManual = jobs.manual;
        nixosManual = (import ./nixos/release-small.nix {
          nixpkgs = self;
        }).nixos.manual.x86_64-linux;
      };

      legacyPackages = forAllSystems (system: import ./. { inherit system; });

      nixosModules = {
        # Profiles included by nixos-generate-config
        notDetected = import ./nixos/modules/installer/scan/not-detected.nix;

        # Additional profiles described in the manual
        allHardware = import ./nixos/modules/profiles/all-hardware.nix;
        base = import ./nixos/modules/profiles/base.nix;
        cloneConfig = import ./nixos/modules/profiles/clone-config.nix;
        demo = import ./nixos/modules/profiles/demo.nix;
        dockerContainer = import ./nixos/modules/profiles/docker-container.nix;
        graphical = import ./nixos/modules/profiles/graphical.nix;
        hardened = import ./nixos/modules/profiles/hardened.nix;
        headless = import ./nixos/modules/profiles/headless.nix;
        installationDevice = import ./nixos/modules/profiles/installation-device.nix;
        minimal = import ./nixos/modules/profiles/minimal.nix;
        qemuGuest = import ./nixos/modules/profiles/qemu-guest.nix;
      };
    };
}
