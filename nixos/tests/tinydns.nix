import ./make-test.nix ({ lib, ...} : {
  name = "tinydns";
  meta = {
    maintainers = with lib.maintainers; [ basvandijk ];
  };
  nodes = {
    nameserver = { config, lib, ... } : let
      ip = (lib.head config.networking.interfaces.eth1.ipv4.addresses).address;
    in {
      networking.nameservers = [ ip ];
      services.tinydns = {
        enable = true;
        inherit ip;
        data = ''
          .foo.bar:${ip}
          +.bla.foo.bar:1.2.3.4:300
        '';
      };
    };
  };
  testScript = ''
    $nameserver->start;
    $nameserver->waitForUnit("tinydns.service");
    $nameserver->succeed("host bla.foo.bar | grep '1\.2\.3\.4'");
  '';
})
