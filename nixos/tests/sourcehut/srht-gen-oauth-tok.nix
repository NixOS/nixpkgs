{ stdenv, pkgs, lib, fetchFromSourcehut }:

let
  perl = pkgs.perl.withPackages (pps: [
    pps.CryptSSLeay
    pps.WWWMechanize
    pps.XMLLibXML
  ]);
in
stdenv.mkDerivation rec {
  pname = "srht-gen-oauth-tok";
  version = "0.1";

  src = fetchFromSourcehut {
    domain = "entropic.network";
    owner = "~nessdoor";
    repo = pname;
    rev = version;
    hash = "sha256-GcqP3XbVw2sR5n4+aLUmA4fthNkuVAGnhV1h7suJYdI=";
  };

  buildInputs = [ perl ];
  nativeBuildInputs = [ perl ];

  installPhase = "install -Dm755 srht-gen-oauth-tok $out/bin/srht-gen-oauth-tok";

  meta = {
    description = "A script to register a new Sourcehut OAuth token for the given user";
    license = lib.licenses.gpl3;
  };
}
