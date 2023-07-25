{ lib
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
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "sublime-music";
  version = "0.12.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "sublime-music";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FPzeFqDOcaiariz7qJwz6P3Wd+ZDxNP57uj+ptMtEyM=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
    sed -i "/--no-cov-on-fail/d" setup.cfg
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
