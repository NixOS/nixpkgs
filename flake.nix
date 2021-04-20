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

      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];

      forAllSystems = f: lib.genAttrs systems (system: f system);

    in
    {
      lib = lib.extend (final: prev: {
        nixosSystem = { modules, ... } @ args:
          import ./nixos/lib/eval-config.nix (args // {
            modules =
              let
                vmConfig = (import ./nixos/lib/eval-config.nix
                  (args // {
                    modules = modules ++ [ ./nixos/modules/virtualisation/qemu-vm.nix ];
                  })).config;

                vmWithBootLoaderConfig = (import ./nixos/lib/eval-config.nix
                  (args // {
                    modules = modules ++ [
                      ./nixos/modules/virtualisation/qemu-vm.nix
                      { virtualisation.useBootLoader = true; }
                      ({ config, ... }: {
                        virtualisation.useEFIBoot =
                          config.boot.loader.systemd-boot.enable ||
                          config.boot.loader.efi.canTouchEfiVariables;
                      })
                    ];
                  })).config;
              in
              modules ++ [
                {
                  system.nixos.versionSuffix =
                    ".${final.substring 0 8 (self.lastModifiedDate or self.lastModified or "19700101")}.${self.shortRev or "dirty"}";
                  system.nixos.revision = final.mkIf (self ? rev) self.rev;

                  system.build = {
                    vm = vmConfig.system.build.vm;
                    vmWithBootLoader = vmWithBootLoaderConfig.system.build.vm;
                  };
                }
              ];
          });
      });

      checks.x86_64-linux.tarball = jobs.tarball;
      devShell = {
        x86_64-linux = import ./shell.nix { system = "x86_64-linux"; };
        x86_64-darwin = import ./shell.nix { system = "x86_64-darwin"; };
        aarch64-linux = import ./shell.nix { system = "aarch64-linux"; };
      };

      htmlDocs = {
        nixpkgsManual = jobs.manual;
        nixosManual = (import ./nixos/release-small.nix {
          nixpkgs = self;
        }).nixos.manual.x86_64-linux;
      };

      legacyPackages = forAllSystems (system: import ./. { inherit system; });

      nixosModules = {
        notDetected = import ./nixos/modules/installer/scan/not-detected.nix;
      };
    };
}
