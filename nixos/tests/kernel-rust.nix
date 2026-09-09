{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

let
  inherit (pkgs.lib)
    const
    filterAttrs
    mapAttrs
    meta
    ;

  kernelRustTest =
    kernelPackages:
    import ./make-test-python.nix (
      { lib, ... }:
      {
        name = "kernel-rust";
        meta.maintainers = with lib.maintainers; [
          blitz
          ma27
        ];
        nodes.machine =
          { config, ... }:
          {
            boot = {
              inherit kernelPackages;
              extraModulePackages = [ config.boot.kernelPackages.rust-out-of-tree-module ];
              kernelPatches = [
                {
                  name = "Rust Support";
                  patch = null;
                  features = {
                    rust = true;
                  };
                }
              ];
            };
          };
        testScript = ''
          machine.wait_for_unit("default.target")
          machine.succeed("modprobe rust_out_of_tree")
        '';
      }
    );

  kernels = {
    inherit (pkgs.linuxKernel.packages) linux_testing;
  }
  // filterAttrs (const (
    x:
    let
      inherit (builtins.tryEval (x.rust-out-of-tree-module or null != null))
        success
        value
        ;
      available = meta.availableOn pkgs.stdenv.hostPlatform x.rust-out-of-tree-module;
    in
    success && value && available
  )) pkgs.linuxKernel.vanillaPackages;
in
mapAttrs (const kernelRustTest) kernels
