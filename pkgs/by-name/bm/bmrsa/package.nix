{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bmrsa";
  version = "11";

  src = fetchurl {
    url = "mirror://sourceforge/bmrsa/bmrsa${finalAttrs.version}.zip";
    sha256 = "0ksd9xkvm9lkvj4yl5sl0zmydp1wn3xhc55b28gj70gi4k75kcl4";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    mkdir bmrsa
    cd bmrsa
    unzip ${finalAttrs.src}
    sed -e 's/gcc/g++/' -i Makefile
    mkdir -p $out/bin
    echo -e 'install:\n\tcp bmrsa '$out'/bin' >> Makefile
  '';

  meta = {
    description = "RSA utility";
    mainProgram = "bmrsa";
    homepage = "http://bmrsa.sourceforge.net/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
