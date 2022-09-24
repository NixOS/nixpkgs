/*
  This test verifies that BirdsiteLIVE starts up correctly and replies to HTTP
  requests. The Twitter API keys used in this tests have been obscured by
  character substitution to prevent trivial automated recognition.
*/
import ./make-test-python.nix ({ lib, pkgs, confined ? false, ... }:
let
  descramble = with lib; builtins.replaceStrings
    (stringToCharacters "QTpVmZ1zLgrjiDa6OtIeGEK4hkdn5BoPYysCb8Rq0XSWJxMNclwfAHFU923vu7")
    (stringToCharacters "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");

  tlsCert = pkgs.runCommand "selfSignedCerts" {
    nativeBuildInputs = with pkgs; [ openssl ];
  } ''
    mkdir -p $out
    openssl req -x509 \
      -subj '/CN=birdsitelive.nixos.test/' -days 49710 \
      -addext 'subjectAltName = DNS:birdsitelive.nixos.test' \
      -keyout "$out/key.pem" -newkey ed25519 \
      -out "$out/cert.pem" -noenc
  '';

  check = pkgs.writers.writeBashBin "check" ''
    set -e -u -o errtrace -o pipefail

    paths=( / /About{,/{Blacklisting,Whitelisting}} )

    for path in "''${paths[@]}"; do
      ${pkgs.curl}/bin/curl -f -S -s -o /dev/null -w '%{response_code}' \
        "https://birdsitelive.nixos.test$path" \
        | grep -F -q 200
    done
  '';

  hosts = nodes: ''
    ${nodes.birdsitelive.networking.primaryIPAddress} birdsitelive.nixos.test
    ${nodes.client.networking.primaryIPAddress} client.nixos.test
  '';
in
{
  name = "birdsitelive";
  nodes = {
    client = { nodes, pkgs, config, ... }: {
      security.pki.certificateFiles = [ "${tlsCert}/cert.pem" ];
      networking.extraHosts = hosts nodes;
      environment.systemPackages = with pkgs; [ check ];
    };

    birdsitelive = { nodes, pkgs, config, ... }: {
      networking.extraHosts = hosts nodes;
      networking.firewall.allowedTCPPorts = [ 443 ];
      systemd.services.birdsitelive.confinement.enable = confined;

      services.birdsitelive = {
        enable = true;
        settings = {
          Instance = {
            Domain = "birdsitelive.nixos.test";
            AdminEmail = "birdsitelive@nixos.test";
          };
          Twitter = {
            ConsumerKey = descramble "r35h4FJ1JlexgjNNtv3IONgfu";
            ConsumerSecret = {
              _secret = "/run/keys/twitter-api-key";
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
    birdsitelive.succeed(('echo F2SkZ6NNhuNjgbRVPHbYsOsJXpxKlCJxzS5xhkkw9RXuKq4hLL'
      ' | tr g5cd3Y1GroT9k42iPnK6sqHBfwSjuIVv0XAxtFNCQDUpLWzElORyZMaehJ8mb7'
      ' 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
      ' >/run/keys/twitter-api-key'))
    birdsitelive.systemctl('start birdsitelive.service')
    birdsitelive.wait_for_unit('birdsitelive.service')
    birdsitelive.wait_for_open_port(5000)
    birdsitelive.systemctl('restart birdsitelive-initdb.service')  # test repeated initialisation
    birdsitelive.wait_for_unit('birdsitelive.service')
    birdsitelive.wait_for_open_port(5000)
    birdsitelive.wait_for_unit('nginx.service')
    client.succeed('check')
  '';
})
