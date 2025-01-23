{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "hawknl";
  version = "1.68";

  src = fetchurl {
    url = "http://urchlay.naptime.net/~urchlay/src/HawkNL${
      lib.replaceStrings [ "." ] [ "" ] version
    }src.zip";
    sha256 = "11shn2fbxj3w0j77w0234pqyj1368x686kkgv09q5yqhi1cdp028";
  };

  nativeBuildInputs = [ unzip ];

  makefile = "makefile.linux";

  patchPhase = ''
    sed -i s/soname,NL/soname,libNL/ src/makefile.linux
  '';

  preInstall = ''
    sed -i s,/usr/local,$out, src/makefile.linux
    mkdir -p $out/lib $out/include
  '';

  meta = {
    homepage = "http://hawksoft.com/hawknl/";
    description = "Free, open source, game oriented network API";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
}
