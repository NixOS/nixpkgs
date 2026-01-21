{
  lib,
  stdenv,
  fetchurl,
  libmad,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "normalize";
  version = "0.7.7";

  src = fetchurl {
    url = "mirror://savannah/normalize/normalize-${finalAttrs.version}.tar.gz";
    hash = "sha256-YFWiq8zGQpbhw4+WUvIFbTo8CWU44WS4uVJuELSGs9g=";
  };

  postPatch = ''
    sed -e '1i #include <string.h>' -i nid3lib/frame_desc.c
    substituteInPlace nid3lib/frame_desc.c \
      --replace-fail "int strcmp();" ""
    sed -e '1i #include <unistd.h>' -i nid3lib/write.c
    substituteInPlace nid3lib/write.c \
      --replace-fail "int ftruncate();" ""
  '';

  buildInputs = [ libmad ];

  meta = {
    homepage = "https://www.nongnu.org/normalize/";
    description = "Audio file normalizer";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
