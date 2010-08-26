{ stdenv, fetchurl, maxima, wxGTK }:

# TODO: Build the correct ${maxima}/bin/maxima store path into wxMaxima so that
#       it can run that binary without relying on $PATH, /etc/wxMaxima.conf, or
#       ~/.wxMaxima.

let
    name    = "wxmaxima";
    version = "0.8.6";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima-${version}.tar.gz";
    sha256 = "09w6gai0jfhl959yrdcdikz5l9kdjshasjk404vl19nfnivdbj9f";
  };

  buildInputs = [maxima wxGTK];

  meta = {
    description = "Cross platform GUI for the computer algebra system Maxima.";
    license = "GPL2";
    homepage = http://wxmaxima.sourceforge.net;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
