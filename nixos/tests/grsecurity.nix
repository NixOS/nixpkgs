# Basic test to make sure grsecurity works

import ./make-test.nix ({ pkgs, ...} : {
  name = "grsecurity";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ copumpkin joachifm ];
  };

  machine = { config, pkgs, ... }:
    { security.grsecurity.enable = true;
      boot.kernel.sysctl."kernel.grsecurity.audit_mount" = 0;
      boot.kernel.sysctl."kernel.grsecurity.deter_bruteforce" = 0;
      networking.useDHCP = false;
    };

  testScript = ''
    subtest "grsec-lock", sub {
      $machine->succeed("systemctl is-active grsec-lock");
      $machine->succeed("grep -Fq 1 /proc/sys/kernel/grsecurity/grsec_lock");
      $machine->fail("echo -n 0 >/proc/sys/kernel/grsecurity/grsec_lock");
    };

    subtest "paxtest", sub {
      # TODO: running paxtest blackhat hangs the vm
      my @pax_mustkill = (
        "anonmap", "execbss", "execdata", "execheap", "execstack",
        "mprotanon", "mprotbss", "mprotdata", "mprotheap", "mprotstack",
      );
      foreach my $name (@pax_mustkill) {
        my $paxtest = "${pkgs.paxtest}/lib/paxtest/" . $name;
        $machine->succeed($paxtest) =~ /Killed/ or die
      }
    };

    # tcc -run executes run-time generated code and so allows us to test whether
    # paxmark actually works (otherwise, the process should be terminated)
    subtest "tcc", sub {
      $machine->execute("echo -e '#include <stdio.h>\nint main(void) { puts(\"hello\"); return 0; }' >main.c");
      $machine->succeed("${pkgs.tinycc.bin}/bin/tcc -run main.c");
    };

    subtest "RBAC", sub {
      $machine->succeed("[ -c /dev/grsec ]");
    };
  '';
})
