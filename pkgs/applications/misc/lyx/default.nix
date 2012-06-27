# I haven't put much effort into this expressions .. so some optional depencencies may be missing - Marc
{ fetchurl, stdenv, texLive, python, makeWrapper, pkgconfig
, libX11, qt
}:

stdenv.mkDerivation rec {
  version = "2.0.3";
  name = "lyx-${version}";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.0.x/${name}.tar.xz";
    sha256 = "1j2sl22w41h4vrgnxv2n0s7d11k6zchjbggjw3ai9yxcahvrj72f";
  };

  buildInputs = [texLive qt python makeWrapper pkgconfig ];

  meta = {
    description = "WYSIWYM frontend for LaTeX, DocBook, etc.";
    homepage = "http://www.lyx.org";
    license = "GPL2";
    maintainers = [ stdenv.lib.maintainers.neznalek ];
    platforms = stdenv.lib.platforms.linux;
  };
}
