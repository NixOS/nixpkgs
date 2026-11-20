# Run with: nix-build -A nixosTests.nixos-test-driver.backdoor
{
  name = "nixos-test-driver.backdoor";

  nodes.machine =
    { pkgs, ... }:
    {
      # Backdoor is unaffected by root shell choice
      users.users.root.shell = "${pkgs.shadow}/bin/nologin";
    };

  testScript = ''
    import os
    import socket
    import time

    machine.wait_for_unit("multi-user.target")

    class DelayedFirstRecv(socket.socket):
        """A socket that waits 5s on first read."""

        waited = False

        def recv(self, bufsize: int, flags: int = 0) -> bytes:
            if not self.waited:
                self.waited = True
                time.sleep(5)
            return super().recv(bufsize, flags)

    with subtest("output arrives whole when the driver is slow to read it"):
        # 1 MB of output, base64-encoded, is several times what the socket
        # buffers hold, and the guest writes it well within the 5 s.
        size = 1_000_000
        shell = machine.shell
        assert shell is not None

        # Slow the first backdoor read, to trigger the data loss that would be
        # caused by QEMU `virtconsole` if used for this.
        slow = DelayedFirstRecv(fileno=os.dup(shell.fileno()))
        # If we were to regress, make it fail quickly using timeout
        slow.settimeout(60)
        machine.shell = slow
        try:
            out = machine.succeed(f"head -c {size} /dev/zero | tr '\\0' x")
            assert slow.waited, "the driver read the shell without calling recv"
        finally:
            machine.shell = shell
            # settimeout sets the non-blocking flag, which `slow` and `shell`
            # share; restore it so as not to confuse the test driver.
            slow.settimeout(None)
            slow.close()
        assert out == "x" * size, f"got {len(out)} of {size} bytes, or bytes other than x"

    with subtest("commands run with a terminal on stdin"):
        machine.succeed("test -t 0")
        machine.succeed(": < /dev/tty")
        machine.succeed(": < /dev/stdin")

    with subtest("commands see root's login shell as SHELL"):
        out = machine.succeed("echo $SHELL")
        assert out.endswith("/bin/nologin\n"), f"got {out!r}"

    with subtest("stderr goes to the serial console, not the output"):
        out = machine.succeed("echo stderr-of-a-command >&2; echo out")
        assert out == "out\n", f"got {out!r}"
        machine.wait_for_console_text("stderr-of-a-command")
  '';
}
