{ stdenv, fetchurl, maxima, wxGTK, makeWrapper }:

let
  name    = "wxmaxima";
  version = "12.01.0";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima-${version}.tar.gz";
    sha256 = "358cdafe81b7e7290f6bb8c93580b0e2f0ae5a4d148a476e5af375aa9bf77054";
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
    description = "Cross platform GUI for the computer algebra system Maxima.";
    license = "GPL2";
    homepage = http://wxmaxima.sourceforge.net;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
