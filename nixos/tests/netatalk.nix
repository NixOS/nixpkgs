{ lib, ... }:
{
  name = "netatalk";

  meta.maintainers = with lib.maintainers; [ nulleric ];

  nodes = {
    server =
      { ... }:
      {
        services.netatalk = {
          enable = true;
          settings = {
            Global = {
              # uams_dhx2.so is a symlink to the PAM-backed UAM, so the
              # system password of the user below is what authenticates.
              "uam list" = "uams_dhx2.so";
            };
            share = {
              path = "/srv/afp";
              "valid users" = "alice";
            };
          };
        };

        networking.firewall.allowedTCPPorts = [ 548 ];

        users.users.alice = {
          isNormalUser = true;
          password = "alice";
        };

        systemd.tmpfiles.rules = [ "d /srv/afp 0700 alice users -" ];
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.netatalk-client ];
      };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("netatalk.service")
    server.wait_for_open_port(548)
    client.wait_for_unit("multi-user.target")

    with subtest("server answers an unauthenticated status request"):
        status = client.succeed("afpgetstatus server")
        assert "AFP" in status, f"no AFP version in status reply: {status}"

    with subtest("client mounts the volume over AFP"):
        # The manager daemon is what forks a per-mount daemon for each mount
        # request; a plain afpfsd would answer status but not mount. Its
        # output goes to the journal because the forked child holds stdout
        # open, which would otherwise block succeed() forever.
        client.succeed("afpfsd --manager --logmethod syslog >/dev/null 2>&1")
        client.wait_until_succeeds("afpc fs status")
        client.succeed("mkdir -p /mnt/afp")
        client.succeed("afpc fs mount -u alice -p alice server:share /mnt/afp")
        client.wait_until_succeeds("afpc fs status /mnt/afp")

    with subtest("a file written on the client lands on the server"):
        client.succeed("echo from-client > /mnt/afp/client.txt")
        server.wait_until_succeeds("test -f /srv/afp/client.txt")
        server.succeed("grep -q from-client /srv/afp/client.txt")
        # The AFP login maps onto the Unix user, so ownership must follow.
        server.succeed("test \"$(stat -c %U /srv/afp/client.txt)\" = alice")

    with subtest("a file written on the server is visible on the client"):
        server.succeed("echo from-server > /srv/afp/server.txt")
        server.succeed("chown alice:users /srv/afp/server.txt")
        client.wait_until_succeeds("grep -q from-server /mnt/afp/server.txt")

    with subtest("the volume got a CNID catalog"):
        # Kept backend-agnostic on purpose: dbd writes a directory here and
        # sqlite (the default from 4.6.0) writes share.sqlite.
        server.succeed("ls /var/lib/netatalk/CNID | grep -q share")

    with subtest("the client unmounts cleanly"):
        client.succeed("afpc fs unmount /mnt/afp")
        client.fail("mountpoint -q /mnt/afp")
        client.succeed("afpc fs exit")
  '';
}
