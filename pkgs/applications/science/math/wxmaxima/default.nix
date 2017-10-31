{ stdenv, fetchurl, maxima, wxGTK, makeWrapper }:

let
  name    = "wxmaxima";
  version = "15.04.0";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima/${version}/wxmaxima-${version}.tar.gz";
    sha256 = "1fm47ah4aw5qdjqhkz67w5fwhy8yfffa5z896crp0d3hk2bh4180";
  };

  buildInputs = [wxGTK maxima makeWrapper];

  postInstall = ''
    # Make sure that wxmaxima can find its runtime dependencies.
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" --prefix PATH ":" "${maxima}/bin"
    done
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://wxmaxima.sourceforge.net;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
