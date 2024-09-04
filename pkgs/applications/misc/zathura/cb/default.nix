{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  gettext,
  libarchive,
}:

stdenv.mkDerivation rec {
  pname = "zathura-cb";
  version = "0.1.10";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    hash = "sha256-ibDKF6gMuh6p/Rs7cvOnFz8KrToGqMNk2GXEmZwYu8g=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
  ];
  buildInputs = [
    libarchive
    zathura_core
    girara
  ];

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = with lib; {
    homepage = "https://pwmt.org/projects/zathura-cb/";
    description = "Zathura CB plugin";
    longDescription = ''
      The zathura-cb plugin adds comic book support to zathura.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jlesquembre ];
  };
}
