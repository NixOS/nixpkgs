{ ... }:
{
  name = "dnscache";

  # Point dns cache at a local tinydns server.
  nodes.machine = {
    services.tinydns = {
      enable = true;
      ip = "127.0.0.2";
      data = ''
        .example.com:127.0.0.2
        +www.example.com:1.2.3.4:300
      '';
    };

    services.dnscache = {
      enable = true;
      ip = "127.0.0.1";
      # postBuild writes the authoritative server for example.com into the
      # chroot root. A successful lookup therefore proves both that dnscache
      # resolves and that postBuild is used.
      postBuild = ''
        echo 127.0.0.2 > "$out/servers/example.com"
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("tinydns.service")
    machine.wait_for_unit("dnscache.service")
    machine.wait_until_succeeds("DNSCACHEIP=127.0.0.1 dnsqr a www.example.com | grep -F 1.2.3.4")
  '';
}
