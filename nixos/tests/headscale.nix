{ pkgs, lib, ... }:
let
  tls-cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req \
      -x509 -newkey rsa:4096 -sha256 -days 365 \
      -nodes -out cert.pem -keyout key.pem \
      -subj '/CN=headscale' -addext "subjectAltName=DNS:headscale"

    mkdir -p $out
    cp key.pem cert.pem $out
  '';
in
{
  name = "headscale";
  meta.maintainers = with lib.maintainers; [
    kradalby
    misterio77
  ];

  nodes =
    let
      headscalePort = 8080;
      stunPort = 3478;
      peer = {
        services.tailscale.enable = true;
        security.pki.certificateFiles = [ "${tls-cert}/cert.pem" ];
      };
    in
    {
      peer1 = peer;
      peer2 = peer;

      headscale = {
        services = {
          headscale = {
            enable = true;
            port = headscalePort;
            settings = {
              server_url = "https://headscale";
              ip_prefixes = [ "100.64.0.0/10" ];
              derp.server = {
                enabled = true;
                region_id = 999;
                stun_listen_addr = "0.0.0.0:${toString stunPort}";
              };
              dns = {
                base_domain = "tailnet";
                override_local_dns = false;
              };
            };
            extraSettings = {
              dns.extra_records = [
                {
                  name = "grafana.myvpn.example.com";
                  type = "A";
                  value = "100.64.0.3";
                }
              ];
            };
          };
          nginx = {
            enable = true;
            virtualHosts.headscale = {
              addSSL = true;
              sslCertificate = "${tls-cert}/cert.pem";
              sslCertificateKey = "${tls-cert}/key.pem";
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString headscalePort}";
                proxyWebsockets = true;
              };
            };
          };
        };
        networking.firewall = {
          allowedTCPPorts = [
            80
            443
          ];
          allowedUDPPorts = [ stunPort ];
        };
        environment.systemPackages = [ pkgs.headscale ];
      };
    };

  # Type checking on extra packages doesn't work yet
  skipTypeCheck = true;
  extraPythonPackages = p: [ p.pyyaml ];

  testScript = ''
    import yaml

    start_all()
    headscale.wait_for_unit("headscale")
    headscale.wait_for_open_port(443)

    # Create headscale user and preauth-key
    headscale.succeed("headscale users create test")
    authkey = headscale.succeed("headscale preauthkeys -u 1 create --reusable")

    # Connect peers
    up_cmd = f"tailscale up --login-server 'https://headscale' --auth-key {authkey}"
    peer1.execute(up_cmd)
    peer2.execute(up_cmd)

    # Check that they are reachable from the tailnet
    peer1.wait_until_succeeds("tailscale ping peer2")
    peer2.wait_until_succeeds("tailscale ping peer1.tailnet")

    with open("/etc/headscale/config.yaml", encoding="utf-8") as config:
        config_dict = yaml.safe_load(config)
        assert "extra_records" in config_dict["dns"].keys(), "Config file does not contain settings from services.headscale.extraSettings."
        assert config_dict["dns"]["extra_records"][0]["name"] == "grafana.myvpn.example.com", "Extra record has wrong name or does not exist."
  '';
}
