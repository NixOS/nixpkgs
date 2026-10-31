{ lib, pkgs }:

let
  certificateDirectory = "/etc/ovn-test-certificates";
in
{
  mkCertificates =
    domains:
    pkgs.runCommand "ovn-test-certificates"
      {
        nativeBuildInputs = [ pkgs.openssl ];
      }
      (
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (domain: names: ''
            mkdir -p "$out/${domain}"
            cd "$out/${domain}"

            openssl req -new -newkey rsa:2048 -nodes -x509 \
              -days 36500 -subj /CN=ovn-test-${domain}-ca \
              -keyout ca.key -out ca.crt

            for name in ${lib.escapeShellArgs names}; do
              openssl req -new -newkey rsa:2048 -nodes \
                -subj "/CN=$name" \
                -keyout "$name.key" -out "$name.csr"
              openssl x509 -req -days 36500 \
                -in "$name.csr" \
                -CA ca.crt -CAkey ca.key -CAcreateserial \
                -out "$name.crt"
            done
          '') domains
        )
      );

  tlsFor = domain: name: {
    privateKey = "${certificateDirectory}/${domain}/${name}.key";
    certificate = "${certificateDirectory}/${domain}/${name}.crt";
    caCertificate = "${certificateDirectory}/${domain}/ca.crt";
  };

  tlsFlags =
    domain: name:
    lib.concatStringsSep " " [
      "--private-key=${certificateDirectory}/${domain}/${name}.key"
      "--certificate=${certificateDirectory}/${domain}/${name}.crt"
      "--ca-cert=${certificateDirectory}/${domain}/ca.crt"
    ];

  node = certificates: address: {
    virtualisation.interfaces.eth1 = {
      vlan = 1;
      assignIP = false;
    };

    environment.etc."ovn-test-certificates".source = certificates;

    networking.interfaces.eth1.ipv4.addresses = [
      {
        inherit address;
        prefixLength = 24;
      }
    ];

  };
}
