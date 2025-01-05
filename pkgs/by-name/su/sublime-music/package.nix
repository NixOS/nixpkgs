{
  lib,
  fetchFromGitHub,
  python3,
  gobject-introspection,
  gtk3,
  pango,
  wrapGAppsHook3,
  chromecastSupport ? false,
  serverSupport ? false,
  keyringSupport ? true,
  notifySupport ? true,
  libnotify,
  networkSupport ? true,
  networkmanager,
  fetchpatch,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sublime-music";
  version = "0.12.0-unstable-2024-01-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sublime-music";
    repo = "sublime-music";
    rev = "0b4ba69a7ff7ad2dfcb0a264587921f323030766";
    hash = "sha256-NoJ50n/AjM738ebQ/Wccwp2l0sC3VBvKovJvDhDa5SU=";
  };

  patches = [
    # Fix loadfile command https://github.com/sublime-music/sublime-music/pull/461
    (fetchpatch {
      url = "https://github.com/sublime-music/sublime-music/commit/1d107fec2ac7f83e0c49bab663273b31c9072411.patch";
      hash = "sha256-fUss4kqlFiXRr37AIaeWEv/4Bpzx5xkW28OEnsjQqzY=";
    })
  ];

  build-system = with python3.pkgs; [
    flit-core
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs =
    [
      gtk3
      pango
    ]
    ++ lib.optional notifySupport libnotify
    ++ lib.optional networkSupport networkmanager;

  propagatedBuildInputs =
    with python3.pkgs;
    [
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
    ++ lib.optional keyringSupport keyring;

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
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
    homepage = "https://sublimemusic.app";
    changelog = "https://github.com/sublime-music/sublime-music/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      albakham
      sumnerevans
    ];
    mainProgram = "sublime-music";
  };
}
