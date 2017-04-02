{ stdenv, fetchurl, cmake, freetype, libpng, mesa, gettext, openssl, perl, libiconv
, qtscript, qtserialport, qttools, makeQtWrapper
, qtmultimedia
}:

stdenv.mkDerivation rec {
  name = "stellarium-${version}";
  version = "0.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "0il751lgnfkx35h1m8fzwwnrygpxjx2a80gng1i1rbybkykf7l3l";
  };

  nativeBuildInputs = [ makeQtWrapper ];

  buildInputs = [
    cmake freetype libpng mesa gettext openssl perl libiconv qtscript
    qtserialport qttools qtmultimedia
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapQtProgram "$out/bin/stellarium"
  '';

  meta = {
    description = "Free open-source planetarium";
    homepage = "http://stellarium.org/";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux; # should be mesaPlatforms, but we don't have qt on darwin
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
