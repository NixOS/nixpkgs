{
  lib,
  fetchFromGitHub,
  python3Packages,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "photini";
  version = "2024.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jim-easterbrook";
    repo = "Photini";
    rev = "refs/tags/${version}";
    hash = "sha256-iTaFyQpC585QPInLvFzgk65+Znvb1kTTsrzEQvy1quY=";
  };

  build-system = with python3Packages; [ setuptools-scm ];
  dependencies = with python3Packages; [
    pyside6
    cachetools
    appdirs
    chardet
    exiv2
    filetype
    requests
    requests-oauthlib
    requests-toolbelt
    pyenchant
    gpxpy
    keyring
    pillow
    toml
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/jim-easterbrook/Photini";
    changelog = "https://photini.readthedocs.io/en/release-${version}/misc/changelog.html";
    description = "An easy to use digital photograph metadata (Exif, IPTC, XMP) editing application";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zebreus ];
    mainProgram = "photini";
  };
}
