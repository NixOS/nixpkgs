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
            # FIXME not needed anymore with systemd 258
            "${pkgs.writeText "ssh.conf" ''
              Host vsock-mux/*
                ProxyCommand ${pkgs.systemd}/lib/systemd/systemd-ssh-proxy %h %p
                ProxyUseFdpass yes
                CheckHostIP no
                StrictHostKeyChecking no
                UserKnownHostsFile /dev/null
            ''}",
            "--",
            "true"
          ],
          check=True
        )
  '';
}
