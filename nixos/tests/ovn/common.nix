{ lib, pkgs }:

let
  certificateDirectory = "/etc/ovn-test-certificates";
in
{
  mkCertificates =
    names:
    pkgs.runCommand "ovn-test-certificates"
      {
        nativeBuildInputs = [ pkgs.openssl ];
        certificateNames = lib.concatStringsSep " " names;
      }
      ''
        mkdir -p "$out"

        openssl req -new -newkey rsa:2048 -nodes -x509 \
          -days 36500 -subj /CN=ovn-test-ca \
          -keyout "$out/ca.key" -out "$out/ca.crt"

        for name in $certificateNames; do
          openssl req -new -newkey rsa:2048 -nodes \
            -subj "/CN=$name" \
            -keyout "$out/$name.key" -out "$out/$name.csr"
          openssl x509 -req -days 36500 \
            -in "$out/$name.csr" \
            -CA "$out/ca.crt" -CAkey "$out/ca.key" -CAcreateserial \
            -out "$out/$name.crt"
        done
      '';

  tlsFor = name: {
    privateKey = "${certificateDirectory}/${name}.key";
    certificate = "${certificateDirectory}/${name}.crt";
    caCertificate = "${certificateDirectory}/ca.crt";
  };

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
