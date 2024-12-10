{
  appstream-glib,
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  glib-networking,
  gobject-introspection,
  gtk4,
  gtksourceview5,
  lib,
  libadwaita,
  libsoup_3,
  meson,
  ninja,
  pkg-config,
  python3,
  stdenv,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "webfont-kit-generator";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "webfont-kit-generator";
    rev = finalAttrs.version;
    hash = "sha256-aD/1moWIiU4zpLTW+VHH9n/sj10vCZ8UzB2ey3mR0/k=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    gobject-introspection
    gtk4 # For gtk4-update-icon-cache
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    gtk4
    gtksourceview5
    libadwaita
    libsoup_3
    (python3.withPackages (
      ps: with ps; [
        fonttools
        pygobject3
      ]
    ))
  ];

  meta = with lib; {
    description = "Webfont Kit Generator is a simple utility that allows you to generate woff, woff2 and the necessary CSS boilerplate from non-web font formats (otf & ttf)";
    mainProgram = "webfontkitgenerator";
    homepage = "https://apps.gnome.org/app/com.rafaelmardojai.WebfontKitGenerator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ benediktbroich ];
    platforms = platforms.unix;
  };
})
