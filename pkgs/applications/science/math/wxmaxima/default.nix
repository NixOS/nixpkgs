{ stdenv, fetchurl, maxima, wxGTK, makeWrapper }:

let
  name    = "wxmaxima";
  version = "13.04.1";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima/${version}/wxMaxima-${version}.tar.gz";
    sha256 = "0irp1m9vr50ym7wfj1c1vbrzd2pip1vmvn9ykqsdf04afkkwkran";
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
    license = "GPL2";
    homepage = http://wxmaxima.sourceforge.net;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
