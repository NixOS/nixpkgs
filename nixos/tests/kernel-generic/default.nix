{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}@args:

with pkgs.lib;

let
  patchedPkgs = pkgs.extend (
    final: prev: {
      kernelPackagesExtensions = prev.kernelPackagesExtensions ++ [
        (
          finalKernelPackages: _:
          let
            finalKernel = finalKernelPackages.kernel;
          in
          {
            hello-world = final.stdenv.mkDerivation {
              name = "hello-module";

              nativeBuildInputs = finalKernel.moduleBuildDependencies;
              makeFlags = finalKernel.commonMakeFlags ++ [
                # Variable refers to the local Makefile.
                "KDIR=${finalKernel.dev}/lib/modules/${finalKernel.modDirVersion}/build"
                # Variable of the Linux src tree's main Makefile.
                "INSTALL_MOD_PATH=$(out)"
              ];

              buildFlags = [ "modules" ];
              installTargets = [ "modules_install" ];

              src = ./hello-world-src;
            };
          }
        )
      ];
    }
  );

  testsForLinuxPackages =
    linuxPackages:
    (import ../make-test-python.nix (
      { pkgs, ... }:
      {
        name = "kernel-${linuxPackages.kernel.version}";
        meta = with pkgs.lib.maintainers; {
          maintainers = [
            nequissimus
            atemu
            ma27
          ];
        };

        nodes.machine =
          { config, ... }:
          {
            # we could/would do something like below, but linuxPackages comes from outside
            # the machine closure, so an overlay doesn't apply to the kernelPackages.
            # nixpkgs.overlays = [
            #   (final: prev: {
            #     kernelPackagesExtensions = prev.kernelPackagesExtensions ++ [ helloWorldExtension ];
            #   })
            # ]

            boot.kernelPackages = linuxPackages;

            boot.extraModulePackages = [ config.boot.kernelPackages.hello-world ];

            boot.kernelModules = [ "hello" ];
          };

        testScript = ''
          assert "Linux" in machine.succeed("uname -s")
          assert "${linuxPackages.kernel.modDirVersion}" in machine.succeed("uname -a")

          assert "Hello world!" in machine.succeed("dmesg")
        '';
      }
    ) args);
  kernels = patchedPkgs.linuxKernel.vanillaPackages // {
    inherit (patchedPkgs.linuxKernel.packages)
      linux_6_12_hardened
      linux_rt_5_10
      linux_rt_5_15
      linux_rt_6_1
      linux_rt_6_6
      linux_libre

      linux_testing
      ;
  };

in
mapAttrs (_: lP: testsForLinuxPackages lP) kernels
// {
  passthru = {
    inherit testsForLinuxPackages;

    # Useful for development testing of all Kernel configs without building full Kernel
    configfiles = mapAttrs (_: lP: lP.kernel.configfile) kernels;

    testsForKernel = kernel: testsForLinuxPackages (patchedPkgs.linuxPackagesFor kernel);
  };
}
