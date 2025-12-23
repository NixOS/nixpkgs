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

stdenv.mkDerivation rec {
  pname = "minder";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = "minder";
    tag = version;
    hash = "sha256-+aAzM+OOOLwF4PJotdYSfFJu8gYp3I2E2r9fNTjJOs4=";
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
}
