# Minica can provide a CA key and cert, plus a key
# and cert for our fake CA server's Web Front End (WFE).
{
  pkgs ? import <nixpkgs> {},
  minica ? pkgs.minica,
  mkDerivation ? pkgs.stdenv.mkDerivation
}:
let
  conf = import ./snakeoil-certs.nix;
  domain = conf.domain;
in mkDerivation {
  name = "test-certs";
  buildInputs = [ minica ];
  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    minica \
      --ca-key ca.key.pem \
      --ca-cert ca.cert.pem \
      --domains ${domain}
  '';

  installPhase = ''
    mkdir -p $out
    mv ca.*.pem $out/
    mv ${domain}/key.pem $out/${domain}.key.pem
    mv ${domain}/cert.pem $out/${domain}.cert.pem
  '';
}
