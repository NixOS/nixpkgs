{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  glib,
  gtk3,
  nemo,
  file-roller,
  cinnamon-translations,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nemo-fileroller";
  version = "6.7.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = "${finalAttrs.version}-unstable";
    hash = "sha256-msmy//e15B6lYLfsqqUhPAYt/PK+c4k6piY7pw4eqkI=";
  };

  sourceRoot = "${finalAttrs.src.name}/nemo-fileroller";

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    glib
    gtk3
    nemo
  ];

  postPatch = ''
    substituteInPlace src/nemo-fileroller.c \
      --replace-fail "file-roller" "${lib.getExe file-roller}"

    substituteInPlace meson.build \
      --replace-fail "config.set_quoted('GNOMELOCALEDIR', get_option('prefix')/get_option('datadir')/'locale')" \
        "config.set_quoted('GNOMELOCALEDIR', '${cinnamon-translations}/share/locale')"
  '';

  env.PKG_CONFIG_LIBNEMO_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/${nemo.extensiondir}";

  meta = {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-fileroller";
    description = "Nemo file roller extension";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
