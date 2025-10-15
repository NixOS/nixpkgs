{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}@args:

let
  testsForLinuxPackages =
    linuxPackages:
    (import ./make-test-python.nix (
      { pkgs, ... }:
      {
        name = "kernel-${linuxPackages.kernel.version}";
        meta = { inherit maintainers; };

        nodes.machine =
          { ... }:
          {
            boot.kernelPackages = linuxPackages;
          };

        testScript = ''
          assert "Linux" in machine.succeed("uname -s")
          assert "${linuxPackages.kernel.modDirVersion}" in machine.succeed("uname -a")
        '';
      }
    ) args);

  # Skip kernels whose definition is `throw`.
  kernelShallowlyEvals = name: kernel: (builtins.tryEval kernel).success;

  kernels = (pkgs.lib.filterAttrs kernelShallowlyEvals pkgs.linuxKernel.vanillaPackages) // {
    inherit (pkgs.linuxKernel.packages)
      linux_6_12_hardened
      linux_rt_5_4
      linux_rt_5_10
      linux_rt_5_15
      linux_rt_6_1
      linux_rt_6_6
      linux_libre
      linux_testing
      ;
  };

  maintainers = with pkgs.lib.maintainers; [
    nequissimus
    atemu
    ma27
  ];

in
builtins.mapAttrs (_: lP: testsForLinuxPackages lP) kernels
// {
  passthru = {
    inherit testsForLinuxPackages;

    # Useful for development testing of all Kernel configs without building full Kernel
    configfiles = builtins.mapAttrs (_: lP: lP.kernel.configfile) kernels;

    testsForKernel = kernel: testsForLinuxPackages (pkgs.linuxPackagesFor kernel);
  };
}
