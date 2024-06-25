{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  glib,
  vala,
  jsonrpc-glib,
  json-glib,
  gtk3,
  pango,
  gtksourceview3,
  libgee,
  vala-lint,
  gobject-introspection,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gvls";
  version = "20.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "esodan";
    repo = "gvls";
    rev = "gvls-${finalAttrs.version}";
    hash = "sha256-Hpn1osUDxK7+P9Yxcp+3Gw8XJ7jC5C9wRa++0QLp7oM=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  patches = [
    # https://gitlab.gnome.org/esodan/gvls/-/merge_requests/14
    (fetchpatch {
      url = "https://gitlab.gnome.org/esodan/gvls/-/commit/35930cc5797f3834491dae837d996371a751c7de.patch";
      hash = "sha256-tDAWLhOCJ+t0UaFEZD9EZKrSI/4FzhE4sZtelx+/wF0=";
    })
  ];

  mesonFlags = [ "-Dvapidir=${placeholder "out"}/share" ];

  buildInputs = [
    glib
    gtk3
    gtksourceview3
    json-glib
    jsonrpc-glib
    libgee
    pango
  ];
  # Tests fail, probably they need http support not available inside the
  # sandbox
  doCheck = false;

  propagatedBuildInputs = [
    vala
    vala-lint
  ];

  meta = {
    description = "Language Server Provider for Vala";
    homepage = "https://gitlab.gnome.org/esodan/gvls";
    license = lib.licenses.lgpl3Plus;
    maintainers = (with lib.maintainers; [
      johnrtitor
    ]) ++ lib.teams.gnome.members;
    platforms = lib.platforms.linux;
  };
})
