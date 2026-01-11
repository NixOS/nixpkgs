{
  lib,
  stdenv,
  fetchurl,
  libpng,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "pngtoico";
  version = "1.0";

  src = fetchurl {
    url = "mirror://kernel/software/graphics/pngtoico/pngtoico-${version}.tar.gz";
    sha256 = "1xb4aa57sjvgqfp01br3dm72hf7q0gb2ad144s1ifrs09215fgph";
  };

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/pngtoico/files/pngtoico-1.0.1-libpng15.patch?id=dec60bb6900d6ebdaaa6aa1dcb845b30b739f9b5";
      hash = "sha256-MeRV4FL37Wq7aFRnjbxPokcBKmPM+h94cnFJmdvHAt0=";
    })
  ];

  configurePhase = ''
    runHook preConfigure

    sed -i s,/usr/local,$out, Makefile

    runHook postConfigure
  '';

  buildInputs = [ libpng ];

  meta = {
    homepage = "https://www.kernel.org/pub/software/graphics/pngtoico/";
    description = "Small utility to convert a set of PNG images to Microsoft ICO format";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    mainProgram = "pngtoico";
  };
}
