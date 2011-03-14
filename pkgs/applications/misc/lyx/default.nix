# I haven't put much effort into this expressions .. so some optional depencencies may be missing - Marc
{ fetchurl, stdenv, texLive, python, makeWrapper
, libX11, qt
}:

stdenv.mkDerivation rec {
  version = "1.6.9";
  name = "lyx-${version}";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/1.6.x/${name}.tar.bz2";
    sha256 = "c5b3602c58db385be5c52ba958f52239c5fd090320ec99d79b7eb861c1597709";
  };

  buildInputs = [texLive qt python makeWrapper ];

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
