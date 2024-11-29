# Minica can provide a CA key and cert, plus a key
# and cert for our fake CA server's Web Front End (WFE).
{
  pkgs ? import <nixpkgs> {},
  minica ? pkgs.minica,
  runCommandCC ? pkgs.runCommandCC,
}:
let
  conf = import ./snakeoil-certs.nix;
  domain = conf.domain;
  domainSanitized = pkgs.lib.replaceStrings ["*"] ["_"] domain;
in
  runCommandCC "generate-tests-certs" {
    buildInputs = [ (minica.overrideAttrs (old: {
    postPatch = ''
      sed -i 's_NotAfter: time.Now().AddDate(2, 0, 30),_NotAfter: time.Now().AddDate(20, 0, 0),_' main.go
    '';
  })) ];

  } ''
    minica \
      --ca-key ca.key.pem \
      --ca-cert ca.cert.pem \
      --domains "${domain}"

    mkdir -p $out
    mv ca.*.pem $out/
    mv ${domainSanitized}/key.pem $out/${domainSanitized}.key.pem
    mv ${domainSanitized}/cert.pem $out/${domainSanitized}.cert.pem
  ''
