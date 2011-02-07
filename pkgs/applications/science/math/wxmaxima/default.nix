{ stdenv, fetchurl, maxima, wxGTK }:

# TODO: Build the correct ${maxima}/bin/maxima store path into wxMaxima so that
#       it can run that binary without relying on $PATH, /etc/wxMaxima.conf, or
#       ~/.wxMaxima.

let
    name    = "wxmaxima";
    version = "0.8.7";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/wxMaxima-${version}.tar.gz";
    sha256 = "0ms141rgkccwf2xfc56km972gl4ga61pk9iz7f7fcsl64zmr5rs0";
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
