{ stdenv, fetchurl, maxima, wxGTK }:

# TODO: Build the correct ${maxima}/bin/maxima store path into wxMaxima so that
#       it can run that binary without relying on $PATH, /etc/wxMaxima.conf, or
#       ~/.wxMaxima.

let
  name    = "wxmaxima";
  version = "11.04.0";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima-${version}.tar.gz";
    sha256 = "1dfwh5ka125wr6wxzyiwz16lk8kaf09rb6lldzryjwh8zi7yw8dm";
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
