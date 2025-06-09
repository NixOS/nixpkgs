{
  lib,
  stdenv,
  cargo,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gi-docgen,
  glib,
  gobject-introspection,
  json-glib,
}:

stdenv.mkDerivation rec {
  pname = "libipuz";
  version = "0.5.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jrb";
    repo = "libipuz";
    rev = version;
    hash = "sha256-8bFMtqRD90SF9uT39Wkjf0eUef+0HgyrqY+DFA/xutI=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    glib
    gobject-introspection
  ];

  buildInputs = [
    gi-docgen
    glib
    json-glib
  ];

  passthru.updateScript = ./update.bash;

  meta = {
    description = "Library for parsing .ipuz puzzle files";
    homepage = "https://gitlab.gnome.org/jrb/libipuz";
    changelog = "https://gitlab.gnome.org/jrb/libipuz/-/blob/${version}/NEWS.md?ref_type=tags";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
