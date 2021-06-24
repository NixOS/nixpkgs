{ fetchFromGitLab
, fetchpatch
, lib
, python3Packages
, gobject-introspection
, gtk3
, pango
, wrapGAppsHook
, xvfb_run
, chromecastSupport ? false
, serverSupport ? false
, keyringSupport ? true
, notifySupport ? true, libnotify
, networkSupport ? true, networkmanager
}:

python3Packages.buildPythonApplication rec {
  pname = "sublime-music";
  version = "0.11.11";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "sublime-music";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r4Tn/7CGDny8Aa4kF4PM5ZKMYthMJ7801X3zPdvXh4Q=";
  };

  patches = [
    # Switch to poetry-core:
    # https://gitlab.com/sublime-music/sublime-music/-/merge_requests/60
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://gitlab.com/sublime-music/sublime-music/-/commit/9b0af19dbdfdcc5a0fa23e73bb34c7135a8c2855.patch";
      sha256 = "sha256-cXG0RvrnBpme6yKWM0nfqMqoK0qPT6spflJ9AaaslVg=";
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    python3Packages.poetry-core
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

  # Use the test suite provided by the upstream project.
  checkInputs = with python3Packages; [
    pytest
    pytest-cov
  ];
  checkPhase = "${xvfb_run}/bin/xvfb-run pytest";

  # Also run the python import check for sanity
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
