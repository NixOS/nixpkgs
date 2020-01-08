let
  container = { writableAPIVFS }: {
    inherit writableAPIVFS;
    autoStart = true;
    config = {
      boot.kernel.sysctl = { "net.ipv4.ip_forward" = false; };
      networking.hostName = "test";
    };
  };
in
import ./make-test-python.nix (
  { pkgs, ... }: {
    name = "containers-writeable-apivfs";
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ xwvvvvwx ];
    };

    machine = {
      containers.allWritable = container { writableAPIVFS = true; };
      containers.netWritable = container { writableAPIVFS = "network"; };
      containers.notWritable = container { writableAPIVFS = false; };
    };

    testScript = ''
      # --- helpers ---


      def succeed(container, cmd):
          return machine.succeed(f"nixos-container run {container} -- sh -c '{cmd}'").strip()


      def fail(container, cmd):
          machine.fail(f"nixos-container run {container} -- sh -c '{cmd}'")


      # --- setup ---


      machine.wait_for_unit("default.target")


      # --- writableAPIVFS = true ---


      with subtest("allWritable: /proc/sys/net is writable"):
          succeed("allWritable", "echo 1 > /proc/sys/net/ipv4/ip_forward")

      with subtest("allWritable: /proc/sys/kernel is writable"):
          succeed("allWritable", "echo allWritable > /proc/sys/kernel/hostname")


      # --- writableAPIVFS = "network" ---


      with subtest("netWritable: /proc/sys/net is writable"):
          succeed("netWritable", "echo 1 > /proc/sys/net/ipv4/ip_forward")

      with subtest("netWritable: /proc/sys/kernel is not writable"):
          fail("netWritable", "echo netWritable > /proc/sys/kernel/hostname")


      # --- writableAPIVFS = false ---


      with subtest("notWritable: /proc/sys/net is not writable"):
          fail("notWritable", "echo 1 > /proc/sys/net/ipv4/ip_forward")

      with subtest("notWritable: /proc/sys/kernel is not writable"):
          fail("notWritable", "echo notWritable > /proc/sys/kernel/hostname")
    '';
  }
)
