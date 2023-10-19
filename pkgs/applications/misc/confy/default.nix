{ blueprint-compiler
, desktop-file-utils
, fetchFromSourcehut
, gobject-introspection
, gtk4
, lib
, libadwaita
, libnotify
, meson
, ninja
, pkg-config
, python3
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "confy";
  version = "0.7.0";

  src = fetchFromSourcehut {
    owner = "~fabrixxm";
    repo = "confy";
    rev = version;
    hash = "sha256-q8WASTNbiBuKb2tPQBmUL9ji60PRAPnYOTYxnUn0MAw=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook
    gobject-introspection
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
    description = "Conferences schedule viewer";
    homepage = "https://confy.kirgroup.net/";
    changelog = "https://git.sr.ht/~fabrixxm/confy/refs/${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
}
