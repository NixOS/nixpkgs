# Minica can provide a CA key and cert, plus a key
# and cert for our fake CA server's Web Front End (WFE).
{ minica, mkDerivation }:
let
  domain = "acme.test";

  selfSignedCertData = mkDerivation {
    name = "test-certs";
    buildInputs = [ minica ];
    phases = [ "buildPhase" "installPhase" ];

    buildPhase = ''
      mkdir ca
      minica \
        --ca-key ca/key.pem \
        --ca-cert ca/cert.pem \
        --domains ${domain}
      chmod 600 ca/*
      chmod 640 ${domain}/*.pem
    '';

    installPhase = ''
      mkdir -p $out
      mv ${domain} ca $out/
    '';
  };
in {
  inherit domain;
  ca = {
    cert = "${selfSignedCertData}/ca/cert.pem";
    key = "${selfSignedCertData}/ca/key.pem";
  };
  "${domain}" = {
    cert = "${selfSignedCertData}/${domain}/cert.pem";
    key = "${selfSignedCertData}/${domain}/key.pem";
  };
}
