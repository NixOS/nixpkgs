{
  lib,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromSourcehut,
  gobject-introspection,
  gtk4,
  libadwaita,
  libnotify,
  meson,
  ninja,
  pkg-config,
  python3,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "confy";
  version = "0.9.0";

  src = fetchFromSourcehut {
    owner = "~fabrixxm";
    repo = "confy";
    rev = finalAttrs.version;
    hash = "sha256-dcQ0ynEqrrGjAqQoWXtLMpvBVzpilXGpGWVNaVHp3CY=";
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
    libnotify
    (python3.withPackages (
      ps: with ps; [
        icalendar
        pygobject3
      ]
    ))
  ];

  meta = with lib; {
    changelog = "https://git.sr.ht/~fabrixxm/confy/refs/${finalAttrs.version}";
    description = "Conferences schedule viewer";
    homepage = "https://confy.kirgroup.net/";
    license = licenses.gpl3Plus;
    mainProgram = "confy";
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
})
