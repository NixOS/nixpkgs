{
  lib,
  fetchFromGitHub,
  python3Packages,
  gitUpdater,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "photini";
  version = "2026.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jim-easterbrook";
    repo = "Photini";
    tag = finalAttrs.version;
    hash = "sha256-IztPABT/CVTyWS0bIrypJ05Gk2UlXr3HN7nLCNpejmE=";
  };

  build-system = with python3Packages; [ setuptools-scm ];
  dependencies = with python3Packages; [
    pyside6
    cachetools
    platformdirs
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
    changelog = "https://github.com/jim-easterbrook/Photini/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    description = "Easy to use digital photograph metadata (Exif, IPTC, XMP) editing application";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zebreus ];
    mainProgram = "photini";
  };
})
