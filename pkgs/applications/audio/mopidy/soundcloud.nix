{ lib, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-soundcloud";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-soundcloud";
    rev = "v${version}";
    sha256 = "sha256-1Qqbfw6NZ+2K1w+abMBfWo0RAmIRbNyIErEmalmWJ0s=";
  };

  propagatedBuildInputs = [
    mopidy
    pythonPackages.beautifulsoup4
  ];

  doCheck = false;

  meta = with lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ ];
  };
}
