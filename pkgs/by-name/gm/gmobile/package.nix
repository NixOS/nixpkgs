{
  lib,
  stdenv,
  fetchFromGitLab,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  glib,
  json-glib,
  libuev,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "gmobile";
  version = "0.2.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "gmobile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5OQ2JT7YeEYzKXafwgg0xJk2AvtFw2dtcH3mt+cm1bI=";
  };

  nativeBuildInputs = [
    gtk-doc
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    glib
    json-glib
    libuev
  ];

  meta = {
    description = "Functions useful in mobile related, glib based projects";
    homepage = "https://gitlab.gnome.org/World/Phosh/gmobile";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    platforms = lib.platforms.linux;
  };
})
