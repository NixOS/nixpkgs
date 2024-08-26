{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  libspectre,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-ps";
  version = "0.2.7";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-ps/download/zathura-ps-${finalAttrs.version}.tar.xz";
    hash = "sha256-WJf5IEz1+Xi5QTvnzn/r3oQxV69I41GTjt8H2/kwjkY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
  ];

  buildInputs = [
    libspectre
    zathura_core
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = {
    homepage = "https://pwmt.org/projects/zathura-ps/";
    description = "Zathura PS plugin";
    longDescription = ''
      The zathura-ps plugin adds PS support to zathura by using the
      libspectre library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
