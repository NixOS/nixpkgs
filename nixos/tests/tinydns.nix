import ./make-test.nix ({ pkgs, lib, ... }:
let
  keys = import ./ssh-keys.nix pkgs;
in {
  name = "tinydns";
  meta.maintainers = with lib.maintainers; [ basvandijk spacefrogg ];

  nodes = {
    authority = { lib, ... }: {
      services.tinydns."0.0.0.0".enable = true;
      services.tinydns."0.0.0.0".listenTCP = true;
      services.tinydns."0.0.0.0".data = [
        ''
        .example.com:127.0.0.2:b
        =current.example.com:127.0.0.127
        +future.example.com:127.0.0.127''
        [ "TXT" "_kerberos.example.com" "EXAMPLE.COM" 360 ]
        [ "SRV" "_kerberos._udp.example.com" 10 100 88 "current.example.com." ]
        [ "URI" "_kerberos.EXAMPLE.COM" 10 1 "krb5srv:m:udp:current.example.com" null 1542812577]
        [ "URI" "_kerberos.EXAMPLE.COM" 10 1 "krb5srv:m:udp:future.example.com"  "" "410000005c6bd4d3"]
        [ "TXT" "verylong.example.com" "loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong"]
      ];
      services.tinydns."0.0.0.0".secondaries.subordinate = {
        # Inject ssh options
        uri = "-o StrictHostKeyChecking=no tinydns@192.168.1.2";
        sshKey = "/run/tinydns-0.0.0.0/key";
      };
    };
    subordinate = { ... }: {
      networking.firewall.enable = false;
      services.openssh.enable = true;
      services.tinydns."0.0.0.0".enable = true;
      services.tinydns."0.0.0.0".secondary.enable = true;
      services.tinydns."0.0.0.0".secondary.sshKey = keys.snakeOilPublicKey;
    };
  };

  testScript = ''
    startAll;

    $authority->waitForUnit('tinydns-0.0.0.0.service');
    $authority->execute('cp ${keys.snakeOilPrivateKey} /run/tinydns-0.0.0.0/key; chmod 600 /run/tinydns-0.0.0.0/key; chown tinydns /run/tinydns-0.0.0.0/key');
    $authority->execute('systemctl stop axfrdns-0.0.0.0.socket');
    $subordinate->waitForUnit('tinydns-0.0.0.0.service');
    $subordinate->waitForUnit('sshd.service');

    # Authority-local tests
    # NS
    $authority->succeed('dnsq NS example.com 127.0.0.1 | grep -qF "answer: example.com 259200 NS b.ns.example.com"');
    # TXT
    $authority->succeed('dnsq TXT _kerberos.example.com 127.0.0.1 | grep -qF "answer: _kerberos.example.com 360 16 \013EXAMPLE.COM"');

    # Long record. Must fail, as TCP service is not running.
    $authority->succeed('dnsq TXT verylong.example.com 127.0.0.1 | grep -qF "connection refused"');
    # Start TCP service and repeat
    $authority->execute('systemctl start axfrdns-0.0.0.0.socket');
    $authority->waitForUnit('axfrdns-0.0.0.0.socket');
    $authority->succeed('dnsq TXT verylong.example.com 127.0.0.1 | grep -qF "568 bytes, 1+1+0+0 records"');
    # SRV
    $authority->succeed('dnsq 33 _kerberos._udp.example.com 127.0.0.1 | grep -qF "answer: _kerberos._udp.example.com 86400 33 \000\012\000d\000X\007current\007example\003com\000"');
    # URI, expect 'current.example.com' but not 'future.example.com'
    $authority->succeed('dnsq 256 _kerberos.example.com 127.0.0.1 | grep -qF "answer: _kerberos.example.com 86400 256 \000\012\000\001krb5srv:m:udp:current.example.com"');
    $authority->fail('dnsq 256 _kerberos.example.com 127.0.0.1 | grep -qF "answer: _kerberos.example.com 86400 256 \000\012\000\001krb5srv:m:udp:future.example.com"');

    # Must fail, database was not transferred to subordinate, yet.
    $authority->fail('dnsq NS example.com 192.168.1.2 | grep -qF "answer: example.com 259200 NS b.ns.example.com"');
    # Transfer database and retry
    $authority->succeed('systemctl reload tinydns-0.0.0.0.service');
    $subordinate->succeed('dnsq NS example.com 127.0.0.1 | grep -qF "answer: example.com 259200 NS b.ns.example.com"');
    $authority->succeed('dnsq NS example.com 192.168.1.2 | grep -qF "answer: example.com 259200 NS b.ns.example.com"');
  '';
})
