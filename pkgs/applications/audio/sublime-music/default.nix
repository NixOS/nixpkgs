{ lib
<<<<<<< HEAD
=======
, fetchFromGitLab
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, python3
, gobject-introspection
, gtk3
, pango
, wrapGAppsHook
, xvfb-run
, chromecastSupport ? false
, serverSupport ? false
, keyringSupport ? true
, notifySupport ? true
, libnotify
, networkSupport ? true
, networkmanager
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      semver = super.semver.overridePythonAttrs (oldAttrs: rec {
        version = "2.13.0";
        src = fetchFromGitHub {
          owner = "python-semver";
          repo = "python-semver";
          rev = "refs/tags/${version}";
          hash = "sha256-IWTo/P9JRxBQlhtcH3JMJZZrwAA8EALF4dtHajWUc4w=";
        };
      });
<<<<<<< HEAD

      dataclasses-json = super.dataclasses-json.overridePythonAttrs (oldAttrs: rec {
        version = "0.5.7";
        src = fetchFromGitHub {
          owner = "lidatong";
          repo = "dataclasses-json";
          rev = "refs/tags/v${version}";
          hash = "sha256-0tw5Lz+c4ymO+AGpG6THbiALWGBrehC84+yWWk1eafc=";
        };
        nativeBuildInputs = [ python3.pkgs.setuptools ];
      });
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "sublime-music";
<<<<<<< HEAD
  version = "0.12.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "sublime-music";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FPzeFqDOcaiariz7qJwz6P3Wd+ZDxNP57uj+ptMtEyM=";
=======
  version = "0.11.16";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "sublime-music";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-n77mTgElwwFaX3WQL8tZzbkPwnsyQ08OW9imSOjpBlg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
<<<<<<< HEAD
=======
  ] ++ (with python.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ]);

  # Can be removed in later versions (probably > 0.11.16)
  pythonRelaxDeps = [
    "deepdiff"
    "python-mpv"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
    sed -i "/--no-cov-on-fail/d" setup.cfg
<<<<<<< HEAD

    # https://github.com/sublime-music/sublime-music/commit/f477659d24e372ed6654501deebad91ae4b0b51c
    sed -i "s/python-mpv/mpv/g" pyproject.toml
=======
    # https://github.com/sublime-music/sublime-music/pull/370
    # Can be removed in later versions (probably > 0.11.16)
    substituteInPlace pyproject.toml \
      --replace 'python-Levenshtein = "^0.12.0"' 'Levenshtein = ">0.12.0"'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  buildInputs = [
    gtk3
    pango
  ]
  ++ lib.optional notifySupport libnotify
  ++ lib.optional networkSupport networkmanager
  ;

  propagatedBuildInputs = with python.pkgs; [
    bleach
<<<<<<< HEAD
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
=======
    dataclasses-json
    deepdiff
    fuzzywuzzy
    mpv
    peewee
    pygobject3
    levenshtein
    python-dateutil
    requests
    semver
  ]
  ++ lib.optional chromecastSupport pychromecast
  ++ lib.optional keyringSupport keyring
  ++ lib.optional serverSupport bottle
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ;

  nativeCheckInputs = with python.pkgs; [
    pytest
  ];

  checkPhase = ''
    ${xvfb-run}/bin/xvfb-run pytest
  '';

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
  };
}
