{
  lib,
  stdenv,
  fetchzip,
  autoreconfHook,
  dos2unix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpgf";
  version = "7.21.7";

  src = fetchzip {
    url = "mirror://sourceforge/libpgf/libpgf/${finalAttrs.version}/libpgf.zip";
    hash = "sha256-TAWIuikijfyeTRetZWoMMdB/FeGAR7ZjNssVxUevlVg=";
  };

  postPatch = ''
    find . -type f | xargs dos2unix
    mv README.txt README
  '';

  nativeBuildInputs = [
    autoreconfHook
    dos2unix
  ];

  meta = {
    homepage = "https://www.libpgf.org/";
    description = "Progressive Graphics Format";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
