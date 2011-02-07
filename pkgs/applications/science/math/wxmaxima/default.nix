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
    sha256 = "40e792eb27866ae68e3b3fa67983518fd0274eaad314e6ba709cb1f972204157";
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
