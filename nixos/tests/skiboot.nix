import ./make-test-python.nix ({ pkgs, ... }: {
  name = "skiboot";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ moody ];
  };

  nodes.machine =
    { pkgs, ... }:

    {
      environment.systemPackages = with pkgs; [
        skiboot-qemu
        qemu
      ];

      virtualisation.memorySize = 1536;
    };

  testScript = ''
    hw = "Hello World!"
    assert hw in machine.succeed("qemu-system-ppc64 -M powernv8 -cpu power8 -nographic -bios ${pkgs.skiboot-qemu}/skiboot.lid -kernel ${pkgs.skiboot-qemu.test}/hello_kernel")
  '';
})
