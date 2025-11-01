{ lib, ... }:
{
  name = "bpf";
  meta.maintainers = with lib.maintainers; [ martinetd ];

  nodes.machine =
    { pkgs, ... }:
    {
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
    print(machine.succeed("bpftrace -e 'BEGIN { print(\"ok\\n\"); exit(); }'"))
    # tracepoint
    print(machine.succeed("bpftrace -e 'tracepoint:syscalls:sys_enter_* { print(probe); exit() }'"))
    # kprobe
    print(machine.succeed("bpftrace -e 'kprobe:schedule { print(probe); exit() }'"))
    # BTF
    print(machine.succeed("bpftrace -e 'kprobe:schedule { "
        "    printf(\"tgid: %d\\n\", ((struct task_struct*) curtask)->tgid); exit() "
        "}'"))
    # module BTF (bpftrace >= 0.17)
    print(machine.succeed("bpftrace -e 'fentry:nft_trans_alloc_gfp { "
        "    printf(\"portid: %d\\n\", args->ctx->portid); "
        "} BEGIN { exit() }'"))
    # glibc includes
    print(machine.succeed("bpftrace -e '#include <errno.h>\n"
        "BEGIN { printf(\"ok %d\\n\", EINVAL); exit(); }'"))
  '';
}
