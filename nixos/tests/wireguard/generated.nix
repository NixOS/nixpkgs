import ../make-test-python.nix ({ pkgs, lib, kernelPackages ? null, ... } : {
  name = "wireguard-generated";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 grahamc ];
  };

  nodes = {
    peer1 = {
      boot = lib.mkIf (kernelPackages != null) { inherit kernelPackages; };
      networking.firewall.allowedUDPPorts = [ 12345 ];
      networking.wireguard.interfaces.wg0 = {
        ips = [ "10.10.10.1/24" ];
        listenPort = 12345;
        privateKeyFile = "/etc/wireguard/private";
        generatePrivateKeyFile = true;

      };
    };

    peer2 = {
      boot = lib.mkIf (kernelPackages != null) { inherit kernelPackages; };
      networking.firewall.allowedUDPPorts = [ 12345 ];
      networking.wireguard.interfaces.wg0 = {
        ips = [ "10.10.10.2/24" ];
        listenPort = 12345;
        privateKeyFile = "/etc/wireguard/private";
        generatePrivateKeyFile = true;
      };
    };
  };

  testScript = ''
    start_all()

    peer1.wait_for_unit("wireguard-wg0.service")
    peer2.wait_for_unit("wireguard-wg0.service")

    retcode, peer1pubkey = peer1.execute("wg pubkey < /etc/wireguard/private")
    if retcode != 0:
        raise Exception("Could not read public key from peer1")

    retcode, peer2pubkey = peer2.execute("wg pubkey < /etc/wireguard/private")
    if retcode != 0:
        raise Exception("Could not read public key from peer2")

    peer1.succeed(
        "wg set wg0 peer {} allowed-ips 10.10.10.2/32 endpoint 192.168.1.2:12345 persistent-keepalive 1".format(
            peer2pubkey.strip()
        )
    )
    peer1.succeed("ip route replace 10.10.10.2/32 dev wg0 table main")

    peer2.succeed(
        "wg set wg0 peer {} allowed-ips 10.10.10.1/32 endpoint 192.168.1.1:12345 persistent-keepalive 1".format(
            peer1pubkey.strip()
        )
    )
    peer2.succeed("ip route replace 10.10.10.1/32 dev wg0 table main")

    peer1.succeed("ping -c1 10.10.10.2")
    peer2.succeed("ping -c1 10.10.10.1")
  '';
})
