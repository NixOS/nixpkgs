{ lib, python3Packages, gobject-introspection, gtk3, pango, wrapGAppsHook

, chromecastSupport ? false
, serverSupport ? false
, keyringSupport ? true
, notifySupport ? true, libnotify
, networkSupport ? true, networkmanager
}:

python3Packages.buildPythonApplication rec {
  pname = "sublime-music";
  version = "0.11.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1rnjc8pjfaq67mq10gy939g77azc80lxf77s9nsaxds4q5j1yrl2";
  };

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.setuptools
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    pango
  ]
   ++ lib.optional notifySupport libnotify
   ++ lib.optional networkSupport networkmanager
  ;

  propagatedBuildInputs = with python3Packages; [
    dataclasses-json
    deepdiff
    fuzzywuzzy
    mpv
    peewee
    pygobject3
    python-Levenshtein
    python-dateutil
    requests
    semver
  ]
   ++ lib.optional chromecastSupport PyChromecast
   ++ lib.optional keyringSupport keyring
   ++ lib.optional serverSupport bottle
  ;

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  meta = with lib; {
    description = "GTK3 Subsonic/Airsonic client";
    homepage = "https://sublimemusic.app/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ albakham ];
  };
}
