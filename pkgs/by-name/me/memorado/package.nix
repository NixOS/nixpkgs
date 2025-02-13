{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gtk4,
  pkg-config,
  libadwaita,
  blueprint-compiler,
  python3,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "memorado";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "wbernard";
    repo = "Memorado";
    tag = version;
    hash = "sha256-HNZdWRATjSfMk0e99CERPuR891549+wS/WeA7XGFxto=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    (python3.withPackages (
      ps: with ps; [
        pygobject3
      ]
    ))
  ];

  meta = with lib; {
    description = "Simple and clean flashcard memorizing app";
    homepage = "https://github.com/wbernard/Memorado";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
