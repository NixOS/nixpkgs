# Copy of ../common/acme/server/generate-certs.nix
# to generate wildcard certificates with the directory
# structure expected by Sandhole.
{
  pkgs,
  domain,
  minica ? pkgs.minica,
  mkDerivation ? pkgs.stdenv.mkDerivation,
}:

let
  caKey = ../common/acme/server/ca.key.pem;
  caCert = ../common/acme/server/ca.cert.pem;
in

mkDerivation {
  name = "sandhole-generate-certs";
  buildInputs = [
    (minica.overrideAttrs (old: {
      prePatch = ''
        sed -i 's_NotAfter: time.Now().AddDate(2, 0, 30),_NotAfter: time.Now().AddDate(20, 0, 0),_' main.go
      '';
    }))
  ];
  dontUnpack = true;

  buildPhase = ''
    minica \
      --ca-key ${caKey} \
      --ca-cert ${caCert} \
      --domains '${domain},*.${domain}'
  '';

  installPhase = ''
    mkdir -p $out/${domain}
    cp ${caKey} $out/ca.key.pem
    cp ${caCert} $out/ca.cert.pem
    cp ${domain}/key.pem $out/${domain}/privkey.pem
    cp ${domain}/cert.pem $out/${domain}/fullchain.pem
  '';
}
