<<<<<<< HEAD
{ blueprint-compiler
, desktop-file-utils
, fetchFromSourcehut
, gobject-introspection
, gtk4
, lib
, libadwaita
, libnotify
=======
{ appstream-glib
, desktop-file-utils
, fetchurl
, gobject-introspection
, gtk3
, lib
, libnotify
, libhandy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, meson
, ninja
, pkg-config
, python3
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "confy";
<<<<<<< HEAD
  version = "0.7.0";

  src = fetchFromSourcehut {
    owner = "~fabrixxm";
    repo = "confy";
    rev = version;
    hash = "sha256-q8WASTNbiBuKb2tPQBmUL9ji60PRAPnYOTYxnUn0MAw=";
  };

  nativeBuildInputs = [
    blueprint-compiler
=======
  version = "0.6.4";

  src = fetchurl {
    url = "https://git.sr.ht/~fabrixxm/confy/archive/${version}.tar.gz";
    sha256 = "0v74pdyihj7r9gb3k2rkvbphan27ajlvycscd8xzrnsv74lcmbpm";
  };

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook
<<<<<<< HEAD
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    libadwaita
=======
  ];

  buildInputs = [
    gobject-introspection
    gtk3
    libhandy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libnotify
    (python3.withPackages (ps: with ps; [
      icalendar
      pygobject3
    ]))
  ];

  postPatch = ''
<<<<<<< HEAD
    patchShebangs build-aux/meson/postinstall.py
=======
    # Remove executable bits so that meson runs the script with our Python interpreter
    chmod -x build-aux/meson/postinstall.py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Conferences schedule viewer";
    homepage = "https://confy.kirgroup.net/";
    changelog = "https://git.sr.ht/~fabrixxm/confy/refs/${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ michaelgrahamevans ];
  };
}
