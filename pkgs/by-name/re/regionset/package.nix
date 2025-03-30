{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.2";
in
stdenv.mkDerivation {
  pname = "regionset";
  inherit version;

  src = fetchurl {
    url = "http://linvdr.org/download/regionset/regionset-${version}.tar.gz";
    sha256 = "1fgps85dmjvj41a5bkira43vs2aiivzhqwzdvvpw5dpvdrjqcp0d";
  };

  installPhase = ''
    install -Dm755 {.,$out/bin}/regionset
    install -Dm644 {.,$out/share/man/man8}/regionset.8
  '';

  meta = with lib; {
    inherit version;
    homepage = "http://linvdr.org/projects/regionset/";
    description = "Tool for changing the region code setting of DVD players";
    mainProgram = "regionset";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
