{
  lib,
  fetchFromGitHub,
  pythonPackages,
  mopidy,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-soundcloud";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-soundcloud";
    tag = "v${version}";
    sha256 = "sha256-1Qqbfw6NZ+2K1w+abMBfWo0RAmIRbNyIErEmalmWJ0s=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.beautifulsoup4
  ];

  doCheck = false;

  pythonImportsCheck = [ "mopidy_soundcloud" ];

  meta = with lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ ];
  };
}
