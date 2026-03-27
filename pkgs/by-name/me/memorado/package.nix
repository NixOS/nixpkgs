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

stdenv.mkDerivation (finalAttrs: {
  pname = "memorado";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "wbernard";
    repo = "Memorado";
    tag = finalAttrs.version;
    hash = "sha256-pHbZ8zBfgAHLmCaMRS4MS/awFat41OG++hSSHz3k2KM=";
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

  meta = {
    description = "Simple and clean flashcard memorizing app";
    homepage = "https://github.com/wbernard/Memorado";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onny ];
  };
})
