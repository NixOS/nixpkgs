{ stdenv, fetchurl, cmake, freetype, libpng, mesa, gettext, openssl, perl, libiconv
, qtscript, qtserialport, qttools, makeQtWrapper
}:

stdenv.mkDerivation rec {
  name = "stellarium-0.14.3";

  src = fetchurl {
    url = "mirror://sourceforge/stellarium/${name}.tar.gz";
    sha256 = "1919wzlvhfxdxficbwhp31xlhm0571grgcmsfdp5y36z9yqwahfy";
  };

  nativeBuildInputs = [ makeQtWrapper ];

  buildInputs = [
    cmake freetype libpng mesa gettext openssl perl libiconv qtscript
    qtserialport qttools
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
