{
  lib,
  pythonPackages,
  fetchFromGitHub,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-listenbrainz";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suaviloquence";
    repo = "mopidy-listenbrainz";
    tag = "v${version}";
    hash = "sha256-kYZgG2KQMTxMR8tdwwCKkfexDcxcndXG9LSdlnoN/CY=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.musicbrainzngs
  ];

  meta = {
    homepage = "https://github.com/suaviloquence/mopidy-listenbrainz";
    description = "Mopidy extension for recording played tracks and getting recommendations to Listenbrainz, a libre alternative to Last.fm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bohanubis ];
  };
}
