{ pkgs, lib, ... }:
{
  name = "ssh-backdoor";
  sshBackdoor.enable = true;

  nodes.machine = { };

  testScript = ''
    import subprocess

    start_all()
    machine.wait_for_unit("multi-user.target")

    assert driver.vhost_vsock is not None
    host_socket = driver.vhost_vsock.sockets["machine"].host

    with subtest("ssh from the host via systemd-ssh-proxy"):
        subprocess.run(
          [
            "${lib.getExe pkgs.openssh}",
            "-vvv",
            f"vsock-mux/{host_socket}",
            "-o",
            "User=root",
            "-F",
            # The backdoor feature of the driver copies this into NIX_BUILD_TOP.
            # We can't do this here since `enableDebugHook=true;` would halt
            # instead of terminating the test execution if it fails.
            "${pkgs.systemd}/lib/systemd/ssh_config.d/20-systemd-ssh-proxy.conf",
            "--",
            "true"
          ],
          check=True
        )
  '';
}
