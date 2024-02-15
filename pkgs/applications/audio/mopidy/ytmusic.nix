{ lib
, python3
, fetchFromGitHub
, mopidy
}:

let
  python = python3;
in python.pkgs.buildPythonApplication rec {
  pname = "mopidy-ytmusic";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmcdo29";
    repo = "mopidy-ytmusic";
    rev = "v${version}";
    hash = "sha256-2o4fDtaIxRDvIiAGV/9qK/00BmYXasBUwW03fxFcDAU=";
  };

  postPatch = ''
    # only setup.py has up to date dependencies
    rm pyproject.toml
  '';

  nativeBuildInputs = with python.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = [
    (mopidy.override { pythonPackages = python.pkgs; })
    python.pkgs.ytmusicapi
    python.pkgs.pytube
  ];

  pythonImportsCheck = [ "mopidy_ytmusic" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/jmcdo29/mopidy-ytmusic/releases/tag/${src.rev}";
    description = "Mopidy extension for playing music from YouTube Music";
    homepage = "https://github.com/jmcdo29/mopidy-ytmusic";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}
