import ./make-test-python.nix ({ pkgs, ... }: {
  name = "bpf";
  meta.maintainers = with pkgs.lib.maintainers; [ martinetd ];

  nodes.machine = { pkgs, ... }: {
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
    # module BTF (bpftrace >= 0.17)
    # test is currently disabled on aarch64 as kfunc does not work there yet
    # https://github.com/iovisor/bpftrace/issues/2496
    print(machine.succeed("uname -m | grep aarch64 || "
        "bpftrace -e 'kfunc:nft_trans_alloc_gfp { "
        "    printf(\"portid: %d\\n\", args->ctx->portid); "
        "} BEGIN { exit() }'"))
  '';
})
