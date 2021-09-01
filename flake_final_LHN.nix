# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs = { self }:
    let
       
      jobs =     ./pkgs/top-level/release.nix {
        nixpkgs = self;
      };

      lib =     ./lib;

      systems = [
       "aarch64-linux"
       "x86_64-darwin"
       "x86_64-linux"	
       "x86_64-linux"
       "i686-linux"
       "i686-linux"
       "x86_64-darwin"
       "aarch64-linux"
        ];

      forAllSystems = f: lib.genAttrs systems (system: f system);
    
    
    
    jobs =      .pkgs/development/java-modules/junit/default.nix
 
    {
      lib = lib.     (final: prev: {
        nixosSystem = { modules, ... } @ args:
          import ./nixos/lib/eval-config.nix (args // {
            modules =
              let
                vmConfig = (      ./nixos/lib/eval-config.nix
                  (args // {
                    modules = modules ++ [ ./nixos/modules/virtualisation/qemu-vm.nix ];
                  })).config;

                vmWithBootLoaderConfig = (     ./nixos/lib/eval-config.nix
                  (args // {
                    modules = modules ++ [
                      ./nixos/modules/virtualisation/qemu-vm.nix
                      { virtualisation.useBootLoader = true; }
                      ({ config, ... }: {
                        virtualisation.useEFIBoot =
                                 boot.loader.systemd-boot.enable 
                                 boot.loader.efi.canTouchEfiVariables;
                      })
                    ];
                  })).config;

                moduleDeclarationFile =
                  let
                    # Even though `modules` is a mandatory argument for `nixosSystem`, it doesn't
                    # mean that the evaluator always keeps track of its position. If there
                    # are too many levels of indirection, the position gets lost at some point.
                    intermediatePos = builtins.unsafeGetAttrPos "modules" args;
                  in
                    if intermediatePos == null then null else intermediatePos.file;

                # Add the invoking file as error message location for modules
                # that don't have their own locations; presumably inline modules.
                addModuleDeclarationFile =
                  m: if moduleDeclarationFile == null then m else {
                    _file = moduleDeclarationFile;
                    imports = [ m ];
                  };

              in
              map addModuleDeclarationFile modules ++ [
                {
                  system.nixos.versionSuffix =
                    ".${final.substring 0 8 (   .lastModifiedDate or .lastModified or "19700101")}.${self.shortRev or "dirty"}";
                  system.nixos.revision =     .mkIf (self ? rev) self.rev;

                  system.build = {
                    vm = vmConfig.system.build.vm;
                    vmWithBootLoader = vmWithBootLoaderConfig.system.build.vm;
                  };
                }
              ];
          });
      });

      checks.system.tarball = jobs.tarball;

      htmlDocs = {
        nixpkgsManual = jobs.manual;
        nixosManual = (    ./nixos/release-small.nix {
          nixpkgs = self;
        }).nixos.manual.x86_64-linux;
      };

      legacyPackages = forAllSystems (system:      ./. { inherit system; });

      nixosModules = {
        notDetected =      ./nixos/modules/installer/scan/not-detected.nix;
      };
    };

