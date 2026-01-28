{ lib, pkgs, ... }:
{
  name = "bpf";
  meta.maintainers = with lib.maintainers; [ martinetd ];

  nodes.machine =
    { pkgs, config, ... }:
    {
      programs.bcc.enable = true;
      environment.systemPackages = with pkgs; [
        bpftrace
        config.boot.kernelPackages.psc
      ];

      # Simple TCP server for testing psc socket visibility
      systemd.services.tcp-test-server = {
        description = "Simple TCP test server for psc testing";
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${pkgs.python3}/bin/python3 -c "
          import socket
          s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
          s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
          s.bind(('127.0.0.1', 9999))
          s.listen(1)
          print('Listening on port 9999', flush=True)
          while True:
              conn, addr = s.accept()
              conn.close()
          "
        '';
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    ## bcc
    # syscount -d 1 stops 1s after probe started so is good for that
    print(machine.succeed("syscount -d 1"))

    ## bpftrace
    # list probes
    machine.succeed("bpftrace -l")
    # simple BEGIN probe (user probe on bpftrace itself)
    print(machine.succeed("bpftrace -e 'BEGIN { print(\"ok\\n\"); exit(); }'"))
    # tracepoint
    # workaround: this needs more than the default of 1k FD to attach ~350 probes, bump fd limit
    # see https://github.com/bpftrace/bpftrace/issues/2110
    print(machine.succeed("""
        ulimit -n 2048
        bpftrace -e 'tracepoint:syscalls:sys_enter_* { print(probe); exit() }'
    """))
    # kprobe
    print(machine.succeed("bpftrace -e 'kprobe:schedule { print(probe); exit() }'"))
    # BTF
    print(machine.succeed("bpftrace -e 'kprobe:schedule { "
        "    printf(\"tgid: %d\\n\", ((struct task_struct*) curtask)->tgid); exit() "
        "}'"))
    # module BTF (bpftrace >= 0.17)
    # test is currently disabled on aarch64 as kfunc does not work there yet
    # https://github.com/iovisor/bpftrace/issues/2496
    print(machine.succeed("uname -m | grep aarch64 || "
        "bpftrace -e 'kfunc:nft_trans_alloc_gfp { "
        "    printf(\"portid: %d\\n\", args->ctx->portid); "
        "} BEGIN { exit() }'"))
    # glibc includes
    print(machine.succeed("bpftrace -e '#include <errno.h>\n"
        "BEGIN { printf(\"ok %d\\n\", EINVAL); exit(); }'"))

    ## psc - eBPF-powered process scanner
    with subtest("psc basic functionality"):
        # Show version
        print(machine.succeed("psc version"))

        # List available fields and presets
        output = machine.succeed("psc fields")
        print(output)
        assert "process.pid" in output, "psc fields should list process.pid"
        assert "socket" in output.lower(), "psc fields should list socket fields"

        # Basic process listing - should show systemd (PID 1)
        output = machine.succeed("psc --no-color")
        print(output)
        assert "systemd" in output, "psc should show systemd process"

    with subtest("psc tree view"):
        # Tree view shows process hierarchy
        output = machine.succeed("psc --tree --no-color")
        print(output)
        assert "systemd" in output, "psc tree should show systemd"

    with subtest("psc socket output"):
        # Wait for our test server to be listening
        machine.wait_for_unit("tcp-test-server.service")
        machine.wait_for_open_port(9999)

        # Show sockets - should see our test server
        output = machine.succeed("psc -o sockets --no-color")
        print("=== psc -o sockets output ===")
        print(output)
        # The socket output shows processes with their sockets
        # Our python server should appear with port 9999
        assert "python" in output.lower(), "psc -o sockets should show python process"

        # Network preset (compact socket view)
        output = machine.succeed("psc -o network --no-color")
        print("=== psc -o network output ===")
        print(output)

    with subtest("psc file output"):
        # Show open files
        output = machine.succeed("psc -o files --no-color")
        print("=== psc -o files output ===")
        print(output)

    with subtest("psc CEL filtering"):
        # Filter for systemd process by name
        output = machine.succeed("psc 'process.name == \"systemd\"' --no-color")
        print("=== CEL filter for systemd ===")
        print(output)
        assert "systemd" in output, "CEL filter should find systemd"

        # Filter for our test server using contains
        output = machine.succeed("psc 'process.name.contains(\"python\")' --no-color")
        print("=== CEL filter for python ===")
        print(output)
        assert "python" in output, "CEL filter should find python process"

        # Filter by PID 1
        output = machine.succeed("psc 'process.pid == 1' --no-color")
        print("=== CEL filter for PID 1 ===")
        print(output)
        assert "systemd" in output, "CEL filter for PID 1 should show systemd"
  '';
}
