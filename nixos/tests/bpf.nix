import ./make-test-python.nix ({ pkgs, ... }: {
  name = "bpf";
  meta.maintainers = with pkgs.lib.maintainers; [ martinetd ];

  machine = { pkgs, ... }: {
    programs.bcc.enable = true;
    environment.systemPackages = with pkgs; [ bpftrace ];
  };

  testScript = ''
    ## bcc
    # syscount -d 1 stops 1s after probe started so is good for that
    print(machine.succeed("syscount -d 1"))

    ## bpftrace
    # list probes
    machine.succeed("bpftrace -l")
    # simple BEGIN probe (user probe on bpftrace itself)
    print(machine.succeed("bpftrace -e 'BEGIN { print(\"ok\"); exit(); }'"))
    # tracepoint
    print(machine.succeed("bpftrace -e 'tracepoint:syscalls:sys_enter_* { print(probe); exit() }'"))
    # kprobe
    print(machine.succeed("bpftrace -e 'kprobe:schedule { print(probe); exit() }'"))
    # BTF
    print(machine.succeed("bpftrace -e 'kprobe:schedule { "
        "    printf(\"tgid: %d\", ((struct task_struct*) curtask)->tgid); exit() "
        "}'"))
  '';
})
