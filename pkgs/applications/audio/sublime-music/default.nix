{ lib
, fetchFromGitHub
, python3
, gobject-introspection
, gtk3
, pango
, wrapGAppsHook3
, chromecastSupport ? false
, serverSupport ? false
, keyringSupport ? true
, notifySupport ? true
, libnotify
, networkSupport ? true
, networkmanager
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sublime-music";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sublime-music";
    repo = "sublime-music";
    rev = "refs/tags/v${version}";
    hash = "sha256-FPzeFqDOcaiariz7qJwz6P3Wd+ZDxNP57uj+ptMtEyM=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
    sed -i "/--no-cov-on-fail/d" setup.cfg

    # https://github.com/sublime-music/sublime-music/commit/f477659d24e372ed6654501deebad91ae4b0b51c
    sed -i "s/python-mpv/mpv/g" pyproject.toml
  '';

  build-system = with python3.pkgs; [
    flit-core
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    pango
  ]
  ++ lib.optional notifySupport libnotify
  ++ lib.optional networkSupport networkmanager
  ;

  propagatedBuildInputs = with python3.pkgs; [
    bleach
    bottle
    dataclasses-json
    deepdiff
    levenshtein
    mpv
    peewee
    pychromecast
    pygobject3
    python-dateutil
    requests
    semver
    thefuzz
  ]
  ++ lib.optional keyringSupport keyring
  ;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/sublime-music/sublime-music/issues/439
    "test_get_music_directory"
  ];

  pythonImportsCheck = [
    "sublime_music"
  ];

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
    changelog = "https://github.com/sublime-music/sublime-music/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ albakham sumnerevans ];
    mainProgram = "sublime-music";
  };
}
