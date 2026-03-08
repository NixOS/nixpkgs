{
  lib,
  stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  cairo,
  discount,
  glib,
  gtk4,
  gtksourceview5,
  json-glib,
  libarchive,
  libgee,
  libwebp,
  libxml2,
  pantheon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minder";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = "minder";
    tag = finalAttrs.version;
    hash = "sha256-g1rz7yihbMtSvL3B9XTqtOEjjLP+DczOTCp47Cp9GHs=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    discount
    glib
    gtk4
    gtksourceview5
    json-glib
    libarchive
    libgee
    libwebp
    libxml2
    pantheon.granite7
  ];

  postFixup = ''
    for x in $out/bin/*; do
      ln -vrs $x "$out/bin/''${x##*.}"
    done
  '';

  meta = {
    description = "Mind-mapping application for elementary OS";
    homepage = "https://github.com/phase1geo/Minder";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "com.github.phase1geo.minder";
  };
})
