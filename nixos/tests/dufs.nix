{ lib, pkgs, ... }:
{
  name = "dufs";

  meta.maintainers = [ lib.maintainers.font44 ];

  nodes = {
    safe = {
      services.dufs.enable = true;
      environment.systemPackages = [
        pkgs.curl
        pkgs.iproute2
      ];
    };

    authenticated = {
      services.dufs = {
        enable = true;
        bindAddresses = [ "0.0.0.0" ];
        port = 80;
        openFirewall = true;
        environmentFile = "/run/dufs-auth.env";
        settings = {
          allow-upload = true;
          allow-delete = true;
        };
      };

      systemd.tmpfiles.settings."10-dufs-test"."/run/dufs-auth.env".f = {
        mode = "0600";
        user = "dufs";
        group = "dufs";
        argument = "DUFS_AUTH=reader:reader-pass@/:ro|writer:writer-pass@/:rw";
      };

      environment.systemPackages = [ pkgs.curl ];
    };
  };

  testScript = ''
    start_all()

    safe.wait_for_unit("dufs.service")
    safe.wait_for_open_port(5000)
    authenticated.wait_for_unit("dufs.service")
    authenticated.wait_for_open_port(80)

    assert safe.succeed("curl -fsS http://127.0.0.1:5000/__dufs__/health") == '{"status":"OK"}'
    safe.succeed("printf safe-default > /var/lib/dufs/readable.txt && chown dufs:dufs /var/lib/dufs/readable.txt && chmod 600 /var/lib/dufs/readable.txt")
    assert safe.succeed("curl -fsS http://127.0.0.1:5000/readable.txt") == "safe-default"
    safe.fail("curl -fsS -X PUT --data blocked http://127.0.0.1:5000/blocked.txt")
    safe.fail("curl -fsS -X DELETE http://127.0.0.1:5000/readable.txt")
    authenticated.fail("curl -fsS --connect-timeout 2 http://safe:5000/__dufs__/health")
    safe.succeed("ss -H -ltn 'sport = :5000' | grep -F '127.0.0.1:5000'")
    safe.succeed("test \"$(stat -c %U:%G:%a /var/lib/dufs)\" = dufs:dufs:750")
    safe.succeed(
      "test \"$(systemctl show -P User dufs.service)\" = dufs"
      " && test \"$(systemctl show -P Group dufs.service)\" = dufs"
      " && test \"$(systemctl show -P UMask dufs.service)\" = 0077"
      " && test \"$(systemctl show -P StateDirectory dufs.service)\" = dufs"
      " && test \"$(systemctl show -P NoNewPrivileges dufs.service)\" = yes"
      " && test \"$(systemctl show -P PrivateDevices dufs.service)\" = yes"
      " && test \"$(systemctl show -P PrivateTmp dufs.service)\" = yes"
      " && test \"$(systemctl show -P ProtectSystem dufs.service)\" = strict"
      " && test \"$(systemctl show -P MemoryDenyWriteExecute dufs.service)\" = yes"
      " && test -z \"$(systemctl show -P CapabilityBoundingSet dufs.service)\""
      " && for family in AF_UNIX AF_INET AF_INET6 AF_NETLINK; do systemctl show -P RestrictAddressFamilies dufs.service | grep -qw \"$family\"; done"
    )

    authenticated.succeed(
      "systemctl show -P AmbientCapabilities dufs.service | grep -Fxiq cap_net_bind_service"
      " && systemctl show -P CapabilityBoundingSet dufs.service | grep -Fxiq cap_net_bind_service"
    )
    assert safe.succeed("curl -fsS http://authenticated:80/__dufs__/health") == '{"status":"OK"}'
    assert safe.succeed("curl -sS -o /dev/null -w '%{http_code}' http://authenticated:80/") == "401"
    assert safe.succeed("curl -sS -o /dev/null -w '%{http_code}' -u reader:wrong http://authenticated:80/") == "401"

    safe.succeed("curl -fsS -u writer:writer-pass -X MKCOL http://authenticated:80/webdav")
    safe.succeed("curl -fsS -u writer:writer-pass -X PUT --data-binary webdav-payload http://authenticated:80/webdav/payload.txt")
    assert safe.succeed("curl -fsS -u reader:reader-pass http://authenticated:80/webdav/payload.txt") == "webdav-payload"
    assert safe.succeed("curl -sS -o /run/propfind.xml -w '%{http_code}' -u reader:reader-pass -X PROPFIND -H 'Depth: 1' http://authenticated:80/webdav") == "207"
    safe.succeed("grep -F payload.txt /run/propfind.xml")

    safe.fail("curl -fsS -u reader:reader-pass -X MKCOL http://authenticated:80/reader-denied")
    safe.fail("curl -fsS -u reader:reader-pass -X PUT --data denied http://authenticated:80/webdav/reader.txt")
    safe.fail("curl -fsS -u reader:reader-pass -X MOVE -H 'Destination: http://authenticated:80/webdav/reader-moved.txt' http://authenticated:80/webdav/payload.txt")
    safe.fail("curl -fsS -u reader:reader-pass -X DELETE http://authenticated:80/webdav/payload.txt")

    authenticated.succeed("test \"$(stat -c %U:%G:%a /var/lib/dufs/webdav/payload.txt)\" = dufs:dufs:600")
    authenticated.succeed("systemctl restart dufs.service")
    authenticated.wait_for_unit("dufs.service")
    authenticated.wait_for_open_port(80)
    assert safe.succeed("curl -fsS -u reader:reader-pass http://authenticated:80/webdav/payload.txt") == "webdav-payload"

    authenticated.succeed("grep -F 'DUFS_AUTH=reader:reader-pass@/:ro|writer:writer-pass@/:rw' /run/dufs-auth.env")
    authenticated.fail("systemctl show -P ExecStart dufs.service | grep -F writer-pass")
    authenticated.fail("systemctl cat dufs.service | grep -F writer-pass")
    authenticated.fail("journalctl -u dufs.service | grep -F writer-pass")
    authenticated.succeed(
      "config_file=$(systemctl show -P ExecStart dufs.service | grep -o '/nix/store/[^ ;]*-dufs.yaml' | head -n1)"
      " && test -n \"$config_file\""
      " && test -f \"$config_file\""
      " && grep -F 'allow-upload: true' \"$config_file\""
      " && ! grep -F writer-pass \"$config_file\""
    )

    safe.succeed("curl -fsS -u writer:writer-pass -X MOVE -H 'Destination: http://authenticated:80/webdav/moved.txt' http://authenticated:80/webdav/payload.txt")
    safe.fail("curl -fsS -u reader:reader-pass http://authenticated:80/webdav/payload.txt")
    assert safe.succeed("curl -fsS -u reader:reader-pass http://authenticated:80/webdav/moved.txt") == "webdav-payload"
    assert safe.succeed("curl -sS -o /run/propfind-moved.xml -w '%{http_code}' -u reader:reader-pass -X PROPFIND -H 'Depth: 1' http://authenticated:80/webdav") == "207"
    safe.succeed("grep -F moved.txt /run/propfind-moved.xml")
    safe.succeed("curl -fsS -u writer:writer-pass -X DELETE http://authenticated:80/webdav/moved.txt")
    safe.succeed("curl -fsS -u writer:writer-pass -X DELETE http://authenticated:80/webdav")
    safe.fail("curl -fsS -u reader:reader-pass http://authenticated:80/webdav/moved.txt")
  '';
}
