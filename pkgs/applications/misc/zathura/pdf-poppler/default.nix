{
  stdenv,
  lib,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchurl,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  poppler,
  desktop-file-utils,
<<<<<<< HEAD
  appstream,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-pdf-poppler";
<<<<<<< HEAD
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-pdf-poppler";
    tag = finalAttrs.version;
    hash = "sha256-xRTJlPj8sKRjwyuf1hWDyL1n4emLnAEVxVjn6XYn5IU=";
=======
  version = "0.3.3";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-poppler/download/zathura-pdf-poppler-${finalAttrs.version}.tar.xz";
    hash = "sha256-yBLy9ERv1d4Wc04TwC6pqiW6Tjup9ytzLA/5D5ujSTU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
<<<<<<< HEAD
    appstream
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    appstream-glib
    zathura_core
  ];

  buildInputs = [
    poppler
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = {
    homepage = "https://pwmt.org/projects/zathura-pdf-poppler/";
    description = "Zathura PDF plugin (poppler)";
    longDescription = ''
      The zathura-pdf-poppler plugin adds PDF support to zathura by
      using the poppler rendering library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
