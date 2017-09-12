import ./make-test.nix ({ pkgs, ...} : {
  name = "sysctl";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { config, lib, pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages;
      boot.kernel.sysctl = {
        "kernel.dmesg_restrict" = true; # Restrict dmesg access
        "net.core.bpf_jit_enable" = false; # Turn off bpf JIT
        "user.max_user_namespaces" = 0; # Disable user namespaces
        "vm.swappiness" = 2; # Low swap usage
      };
    };

  testScript =
    ''
      $machine->succeed("sysctl kernel.dmesg_restrict | grep 'kernel.dmesg_restrict = 1'");
      $machine->succeed("sysctl net.core.bpf_jit_enable | grep 'net.core.bpf_jit_enable = 0'");
      $machine->succeed("sysctl user.max_user_namespaces | grep 'user.max_user_namespaces = 0'");
      $machine->succeed("sysctl vm.swappiness | grep 'vm.swappiness = 2'");
    '';
})
