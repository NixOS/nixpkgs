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
<<<<<<< HEAD
  version = "0.6";
=======
  version = "0.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wbernard";
    repo = "Memorado";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-pHbZ8zBfgAHLmCaMRS4MS/awFat41OG++hSSHz3k2KM=";
=======
    hash = "sha256-HNZdWRATjSfMk0e99CERPuR891549+wS/WeA7XGFxto=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Simple and clean flashcard memorizing app";
    homepage = "https://github.com/wbernard/Memorado";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onny ];
=======
  meta = with lib; {
    description = "Simple and clean flashcard memorizing app";
    homepage = "https://github.com/wbernard/Memorado";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
