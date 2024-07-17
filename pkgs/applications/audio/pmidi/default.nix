{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  version ? "1.7.1",
  sourceSha256 ? "051mv6f13c8y13c1iv3279k1hhzpz4fm9sfczhgp9sim2bjdj055",
}:
stdenv.mkDerivation {
  pname = "pmidi";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/pmidi/${version}/pmidi-${version}.tar.gz";
    sha256 = sourceSha256;
  };

  buildInputs = [ alsa-lib ];

  meta = with lib; {
    homepage = "https://www.parabola.me.uk/alsa/pmidi.html";
    description = "A straightforward command line program to play midi files through the ALSA sequencer";
    maintainers = with maintainers; [ lheckemann ];
    license = licenses.gpl2;
    mainProgram = "pmidi";
  };
}
