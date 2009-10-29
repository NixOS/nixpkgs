{ stdenv, fetchurl, maxima, wxGTK }:

# TODO: Build the correct ${maxima}/bin/maxima store path into wxMaxima so that
#       it can run that binary without relying on $PATH, /etc/wxMaxima.conf, or
#       ~/.wxMaxima.

let
    name    = "wxmaxima";
    version = "0.8.3";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima-${version}.tar.gz";
    sha256 = "829e732e668f13c3153cc2fb67c7678973bf1bc468fb1b9f437fd0c24f59507a";
  };

  buildInputs = [maxima wxGTK];

  meta = {
    description = "wxWidgets GUI for the computer algebra system Maxima";
    homepage = http://wxmaxima.sourceforge.net;
  };
}
