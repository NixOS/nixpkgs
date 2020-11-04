{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "miniscript";
  version = "unstable-2020-11-04";

  src = fetchFromGitHub {
    owner = "sipa";
    repo = pname;
    rev = "5115dd0bdf70c3e3b728c2c0e9c8af4b7edd13ed";
    sha256 = "0bklhlnl4wkb90rpqhs5n0h6rmnyb3js8ldgynppn27b2kbbmik5";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp miniscript $out/bin/miniscript
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description     = "Compiler and inspector for the miniscript Bitcoin policy language";
    longDescription = "Miniscript is a language for writing (a subset of) Bitcoin Scripts in a structured way, enabling analysis, composition, generic signing and more.";
    homepage        = "http://bitcoin.sipa.be/miniscript/";
    license         = licenses.mit;
    platforms       = platforms.all;
    maintainers     = with maintainers; [ RaghavSood ];
  };
}
