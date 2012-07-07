{ stdenv, fetchurl, maxima, wxGTK, makeWrapper }:

let
  name    = "wxmaxima";
  version = "12.04.0";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima-${version}.tar.gz";
    sha256 = "60110507e0a63738a1f420b22697eaac9bea3866122e072dcd697077e8744824";
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
