import ../make-test-python.nix ({ pkgs, lib, ... }: {
  name = "lxd-ui";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ jnsgruk ];
  };

  nodes.machine = { lib, ... }: {
    virtualisation = {
      lxd.enable = true;
      lxd.ui.enable = true;
    };

    environment.systemPackages = [ pkgs.curl ];
  };

  testScript = ''
    machine.wait_for_unit("sockets.target")
    machine.wait_for_unit("lxd.service")
    machine.wait_for_file("/var/lib/lxd/unix.socket")

    # Wait for lxd to settle
    machine.succeed("lxd waitready")

    # Configure LXC listen address
    machine.succeed("lxc config set core.https_address :8443")
    machine.succeed("systemctl restart lxd")

    # Check that the LXD_UI environment variable is populated in the systemd unit
    machine.succeed("cat /etc/systemd/system/lxd.service | grep 'LXD_UI'")

    # Ensure the endpoint returns an HTML page with 'LXD UI' in the title
    machine.succeed("curl -kLs https://localhost:8443/ui | grep '<title>LXD UI</title>'")
  '';
})
