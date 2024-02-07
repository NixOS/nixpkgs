{ stdenv, pkgs, lib, fetchFromSourcehut, nixosTests }:

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

  passthru.tests.sourcehut = nixosTests.sourcehut;

  meta = {
    description = "A script to register a new Sourcehut OAuth token for a given user";
    longDescription = ''
      srht-gen-oauth-tok is a Perl script for automating the generation of user
      OAuth tokens for Sourcehut-based code forges. This is done by emulating a
      browser and interacting with the Web interface.
    '';
    maintainers = with lib.maintainers; [ nessdoor ];
    mainProgram = "srht-gen-oauth-tok";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
