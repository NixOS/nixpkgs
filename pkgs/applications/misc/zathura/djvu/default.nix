{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchurl,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meson,
  ninja,
  pkg-config,
  gtk3,
  zathura_core,
  girara,
  djvulibre,
  gettext,
  desktop-file-utils,
<<<<<<< HEAD
  appstream,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-djvu";
<<<<<<< HEAD
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-djvu";
    tag = finalAttrs.version;
    hash = "sha256-TehD0uTQguH8f6pdOSIyhr1m87jB3F0WTUNtUM0fPu4=";
=======
  version = "0.2.10";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-djvu/download/zathura-djvu-${finalAttrs.version}.tar.xz";
    hash = "sha256-MunYmSmnbNfT/Lr3n0QYaL2r7fFzF9HRhD+qHxkzjZU=";
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
  ];

  buildInputs = [
    djvulibre
    gettext
    zathura_core
    gtk3
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = {
    homepage = "https://pwmt.org/projects/zathura-djvu/";
    description = "Zathura DJVU plugin";
    longDescription = ''
      The zathura-djvu plugin adds DjVu support to zathura by using the
      djvulibre library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
