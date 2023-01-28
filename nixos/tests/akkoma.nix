/*
  End-to-end test for Akkoma.

  Based in part on nixos/tests/pleroma.

  TODO: Test federation.
*/
import ./make-test-python.nix ({ pkgs, package ? pkgs.akkoma, confined ? false, ... }:
let
  userPassword = "4LKOrGo8SgbPm1a6NclVU5Wb";

  provisionUser = pkgs.writers.writeBashBin "provisionUser" ''
    set -eu -o errtrace -o pipefail

    pleroma_ctl user new jamy jamy@nixos.test --password '${userPassword}' --moderator --admin -y
  '';

  tlsCert = pkgs.runCommand "selfSignedCerts" {
    nativeBuildInputs = with pkgs; [ openssl ];
  } ''
    mkdir -p $out
    openssl req -x509 \
      -subj '/CN=akkoma.nixos.test/' -days 49710 \
      -addext 'subjectAltName = DNS:akkoma.nixos.test' \
      -keyout "$out/key.pem" -newkey ed25519 \
      -out "$out/cert.pem" -noenc
  '';

  sendToot = pkgs.writers.writeBashBin "sendToot" ''
    set -eu -o errtrace -o pipefail

    export REQUESTS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"

    echo '${userPassword}' | ${pkgs.toot}/bin/toot login_cli -i "akkoma.nixos.test" -e "jamy@nixos.test"
    echo "y" | ${pkgs.toot}/bin/toot post "hello world Jamy here"
    echo "y" | ${pkgs.toot}/bin/toot timeline | grep -F -q "hello world Jamy here"

    # Test file upload
    echo "y" | ${pkgs.toot}/bin/toot upload <(dd if=/dev/zero bs=1024 count=1024 status=none) \
      | grep -F -q "https://akkoma.nixos.test/media"
  '';

  checkFe = pkgs.writers.writeBashBin "checkFe" ''
    set -eu -o errtrace -o pipefail

    paths=( / /static/{config,styles}.json /pleroma/admin/ )

    for path in "''${paths[@]}"; do
      diff \
        <(${pkgs.curl}/bin/curl -f -S -s -o /dev/null -w '%{response_code}' "https://akkoma.nixos.test$path") \
        <(echo -n 200)
    done
  '';

  hosts = nodes: ''
    ${nodes.akkoma.networking.primaryIPAddress} akkoma.nixos.test
    ${nodes.client.networking.primaryIPAddress} client.nixos.test
  '';
in
{
  name = "akkoma";
  nodes = {
    client = { nodes, pkgs, config, ... }: {
      security.pki.certificateFiles = [ "${tlsCert}/cert.pem" ];
      networking.extraHosts = hosts nodes;
    };

    akkoma = { nodes, pkgs, config, ... }: {
      networking.extraHosts = hosts nodes;
      networking.firewall.allowedTCPPorts = [ 443 ];
      environment.systemPackages = with pkgs; [ provisionUser ];
      systemd.services.akkoma.confinement.enable = confined;

      services.akkoma = {
        enable = true;
        package = package;
        config = {
          ":pleroma" = {
            ":instance" = {
              name = "NixOS test Akkoma server";
              description = "NixOS test Akkoma server";
              email = "akkoma@nixos.test";
              notify_email = "akkoma@nixos.test";
              registration_open = true;
            };

            ":media_proxy" = {
              enabled = false;
            };

            "Pleroma.Web.Endpoint" = {
              url.host = "akkoma.nixos.test";
            };
          };
        };

        nginx = {
          addSSL = true;
          sslCertificate = "${tlsCert}/cert.pem";
          sslCertificateKey = "${tlsCert}/key.pem";
        };
      };

      services.nginx.enable = true;
      services.postgresql.enable = true;
    };
  };

  testScript = { nodes, ... }: ''
    start_all()
    akkoma.wait_for_unit('akkoma-initdb.service')
    akkoma.systemctl('restart akkoma-initdb.service')  # test repeated initialisation
    akkoma.wait_for_unit('akkoma.service')
    akkoma.wait_for_file('/run/akkoma/socket');
    akkoma.succeed('${provisionUser}/bin/provisionUser')
    akkoma.wait_for_unit('nginx.service')
    client.succeed('${sendToot}/bin/sendToot')
    client.succeed('${checkFe}/bin/checkFe')
  '';
})

