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

stdenv.mkDerivation rec {
  pname = "zathura-ps";
  version = "0.2.7";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
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

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = with lib; {
    homepage = "https://pwmt.org/projects/zathura-ps/";
    description = "Zathura PS plugin";
    longDescription = ''
      The zathura-ps plugin adds PS support to zathura by using the
      libspectre library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
