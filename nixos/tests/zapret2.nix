{ pkgs, lib, ... }:

let
  serverIP = "203.0.113.1";
  clientIP = "203.0.113.2";

  mkInterface = address: {
    ipv4.addresses = lib.singleton {
      inherit address;
      prefixLength = 24;
    };
  };

  # naive DPI to block any TCP stream with "acme.test"
  suricataRules = pkgs.writeText "suricata.rules" ''
    drop tcp-pkt any any -> any any (msg:"Block acme.test"; flow:established,to_server; content:"acme.test"; nocase; sid:1000001; rev:1;)
  '';
in

{
  name = "zapret2";
  meta.maintainers = with lib.maintainers; [ andre4ik3 ];

  nodes = {
    router = {
      virtualisation.vlans = [
        1
        2
      ];
      networking = {
        useDHCP = false;
        interfaces = {
          eth1.ipv4.addresses = lib.mkForce [ ];
          eth2.ipv4.addresses = lib.mkForce [ ];
        };
      };

      # disable suricata-update because this requires an Internet connection
      systemd.services.suricata-update.enable = false;

      services.suricata = {
        enable = true;
        settings = {
          outputs = lib.singleton {
            fast.enabled = true;
          };

          af-packet = [
            {
              interface = "eth1";
              threads = 1;
              defrag = false;
              cluster-type = "cluster_flow";
              cluster-id = 98;
              copy-mode = "ips";
              copy-iface = "eth2";
              buffer-size = 64535;
            }
            {
              interface = "eth2";
              threads = 1;
              cluster-id = 97;
              defrag = false;
              cluster-type = "cluster_flow";
              copy-mode = "ips";
              copy-iface = "eth1";
              buffer-size = 64535;
            }
          ];

          classification-file = "${pkgs.suricata}/etc/suricata/classification.config";
        };
      };

      systemd.tmpfiles.rules = [
        "C /var/lib/suricata/rules/suricata.rules - - - - ${suricataRules}"
        "z /var/lib/suricata/rules/suricata.rules 644 suricata suricata -"
      ];
    };

    server = {
      virtualisation.vlans = [ 1 ];
      networking = {
        useDHCP = false;
        interfaces.eth1 = mkInterface serverIP;
        firewall.allowedTCPPorts = [ 443 ];
      };

      security.pki.certificates = lib.singleton (builtins.readFile ./common/acme/server/ca.cert.pem);

      services.nginx = {
        enable = true;
        virtualHosts."acme.test" = {
          onlySSL = true;
          reuseport = true;
          sslCertificate = ./common/acme/server/acme.test.cert.pem;
          sslCertificateKey = ./common/acme/server/acme.test.key.pem;
          root = lib.mkForce (
            pkgs.runCommandLocal "testdir" { } ''
              mkdir "$out"
              cat > "$out/index.html" <<EOF
              <html><body>Hello World!</body></html>
              EOF
            ''
          );
        };
      };
    };

    client = {
      virtualisation.vlans = [ 2 ];
      networking = {
        useDHCP = false;
        interfaces.eth1 = mkInterface clientIP;
      };

      security.pki.certificates = lib.singleton (builtins.readFile ./common/acme/server/ca.cert.pem);

      services.zapret2 = {
        enable = true;
        firewall.interfaces = [ "eth1" ];
        profiles.default.parameters = [
          "--filter-tcp=443"
          "--payload=tls_client_hello"
          "--lua-desync=multisplit:pos=host+1,midsld,endhost-1"
        ];
      };

      networking.extraHosts = ''
        ${serverIP} acme.test
      '';
    };
  };

  testScript = ''
    start_all()

    for machine in [client, router, server]:
      machine.wait_for_unit("multi-user.target")

    server.wait_for_unit("nginx.service")
    router.wait_for_unit("suricata.service")

    # with nfqws2 running, the request should succeed
    client.wait_for_unit("nfqws2@default.service")
    client.sleep(5)
    client.succeed("curl -s --max-time 5 https://acme.test | grep -F 'Hello World!'")

    # with nfqws2 stopped, the DPI should block it
    client.stop_job("nfqws2@default.service")
    client.fail("curl -s --max-time 5 https://acme.test")
  '';
}
