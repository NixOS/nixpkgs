# I haven't put much effort into this expressions .. so some optional depencencies may be missing - Marc
{ fetchurl, stdenv, texLive, python, makeWrapper, pkgconfig
, libX11, qt
}:

stdenv.mkDerivation rec {
  version = "2.0.0";
  name = "lyx-${version}";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.0.x/${name}.tar.xz";
    sha256 = "a790951d6ed660b254e82d682b478665f119dd522ab4759fdeb5cd8d42f66f61";
  };

  buildInputs = [texLive qt python makeWrapper pkgconfig ];

  # don't ask me why it can't find libX11.so.6
  postInstall = ''
    wrapProgram $out/bin/lyx \
      --prefix LD_LIBRARY_PATH ":" ${libX11}/lib
  '';

  meta = { 
      description = "WYSIWYM frontend for LaTeX, DocBook, etc.";
      homepage = "http://www.lyx.org";
      license = "GPL2";
  };
}
