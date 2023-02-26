{ blueprint-compiler
, desktop-file-utils
, fetchurl
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

  src = fetchurl {
    url = "https://git.sr.ht/~fabrixxm/confy/archive/${version}.tar.gz";
    hash = "sha256-ZvIzgCMDfUW9g+qmY0ZIUoEF0PeVmINjOPwilmFzWDk=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
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
