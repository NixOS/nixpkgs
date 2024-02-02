{ pkgs, ... }: {
  name = "kernel-rust";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ blitz ];
  };

  nodes.machine = { config, pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_testing;

      boot.extraModulePackages = [
        config.boot.kernelPackages.rust-out-of-tree-module
      ];

      boot.kernelPatches = [
        {
          name = "Rust Support";
          patch = null;
          features = {
            rust = true;
          };
        }
      ];
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("modprobe rust_out_of_tree")
  '';
}
