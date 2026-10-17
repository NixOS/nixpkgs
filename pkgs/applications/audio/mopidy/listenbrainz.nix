{
  lib,
  pythonPackages,
  fetchFromGitHub,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-listenbrainz";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suaviloquence";
    repo = "mopidy-listenbrainz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e3VrOILOqBvX3j8jEsseFY6ihZiXIm0ela66VRwvlgg=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.musicbrainzngs
    pythonPackages.pykka
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_listenbrainz" ];

  meta = {
    homepage = "https://github.com/suaviloquence/mopidy-listenbrainz";
    description = "Mopidy extension for recording played tracks and getting recommendations to Listenbrainz, a libre alternative to Last.fm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bohanubis ];
  };
})
