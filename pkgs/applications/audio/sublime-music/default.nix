{ fetchFromGitLab, lib, python3Packages, gobject-introspection, gtk3, pango, wrapGAppsHook
, chromecastSupport ? false
, serverSupport ? false
, keyringSupport ? true
, notifySupport ? true, libnotify
, networkSupport ? true, networkmanager
}:

python3Packages.buildPythonApplication rec {
  pname = "sublime-music";
  version = "0.11.10";

  src = fetchFromGitLab {
    owner = "sublime-music";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g78gmiywg07kaywfc9q0yab2bzxs936vb3157ni1z0flbmcwrry";
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
    bleach
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

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "sublime_music" ];

  postInstall = ''
    install -Dm444 sublime-music.desktop      -t $out/share/applications
    install -Dm444 sublime-music.metainfo.xml -t $out/share/metainfo

    for size in 16 22 32 48 64 72 96 128 192 512 1024; do
        install -Dm444 logo/rendered/"$size".png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/sublime-music.png
    done
  '';

  meta = with lib; {
    description = "GTK3 Subsonic/Airsonic client";
    homepage = "https://sublimemusic.app/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ albakham sumnerevans ];
  };
}
