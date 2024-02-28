{ lib
, blueprint-compiler
, desktop-file-utils
, fetchFromSourcehut
, gobject-introspection
, gtk4
, libadwaita
, libnotify
, meson
, ninja
, pkg-config
, python3
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "confy";
  version = "0.7.1";

  src = fetchFromSourcehut {
    owner = "~fabrixxm";
    repo = "confy";
    rev = finalAttrs.version;
    hash = "sha256-BXQDnRRt2Kuqc1Gwx6Ba6BoEWhICTCsWWkGlBsStyT8=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk4
    libadwaita
    libnotify
    (python3.withPackages (ps: with ps; [
      icalendar
      pygobject3
    ]))
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    changelog = "https://git.sr.ht/~fabrixxm/confy/refs/${finalAttrs.version}";
    description = "Conferences schedule viewer";
    homepage = "https://confy.kirgroup.net/";
    license = licenses.gpl3Plus;
    mainProgram = "confy";
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
})
