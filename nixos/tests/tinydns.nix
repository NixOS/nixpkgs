{ lib, ... }:
{
  name = "tinydns";
  meta = {
    maintainers = with lib.maintainers; [ basvandijk ];
  };
  nodes = {
    nameserver =
      { config, lib, ... }:
      let
        ip = (lib.head config.networking.interfaces.eth1.ipv4.addresses).address;
      in
      {
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
    nameserver.start()
    nameserver.wait_for_unit("tinydns.service")

    # We query tinydns a few times to trigger the bug:
    #
    #   nameserver # [    6.105872] mmap: tinydns (842): VmData 331776 exceed data ulimit 300000. Update limits or use boot option ignore_rlimit_data.
    #
    # which was reported in https://github.com/NixOS/nixpkgs/issues/119066.
    # Without the patch <nixpkgs/pkgs/tools/networking/djbdns/softlimit.patch>
    # it fails on the 10th iteration.
    nameserver.succeed(
        """
          for i in {1..100}; do
            host bla.foo.bar 192.168.1.1 | grep '1\.2\.3\.4'
          done
        """
    )
  '';
}
