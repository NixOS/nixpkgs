{ stdenv, fetchurl, maxima, wxGTK, makeWrapper }:

let
  name    = "wxmaxima";
  version = "12.09.0";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima-${version}.tar.gz";
    sha256 = "5803ab62fc791bcb87f0d0f38357dba6fccc4efa61cb9f709e142c2954b1305d";
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
