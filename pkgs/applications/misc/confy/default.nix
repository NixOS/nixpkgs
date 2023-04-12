{ appstream-glib
, desktop-file-utils
, fetchurl
, gobject-introspection
, gtk3
, lib
, libnotify
, libhandy
, meson
, ninja
, pkg-config
, python3
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "confy";
  version = "0.6.4";

  src = fetchurl {
    url = "https://git.sr.ht/~fabrixxm/confy/archive/${version}.tar.gz";
    sha256 = "0v74pdyihj7r9gb3k2rkvbphan27ajlvycscd8xzrnsv74lcmbpm";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    gtk3
    libhandy
    libnotify
    (python3.withPackages (ps: with ps; [
      icalendar
      pygobject3
    ]))
  ];

  postPatch = ''
    # Remove executable bits so that meson runs the script with our Python interpreter
    chmod -x build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "Conferences schedule viewer";
    homepage = "https://confy.kirgroup.net/";
    changelog = "https://git.sr.ht/~fabrixxm/confy/refs/${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
}
