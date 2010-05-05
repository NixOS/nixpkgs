{ stdenv, fetchurl, maxima, wxGTK }:

# TODO: Build the correct ${maxima}/bin/maxima store path into wxMaxima so that
#       it can run that binary without relying on $PATH, /etc/wxMaxima.conf, or
#       ~/.wxMaxima.

let
    name    = "wxmaxima";
    version = "0.8.5";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima-${version}.tar.gz";
    sha256 = "794317fa2a8d0c2e88c3e5d238c5b81a3e11783ec4a692468b51f15bf5d294f2";
  };

  buildInputs = [maxima wxGTK];

  meta = {
    description = "wxWidgets GUI for the computer algebra system Maxima";
    homepage = http://wxmaxima.sourceforge.net;
  };
}
