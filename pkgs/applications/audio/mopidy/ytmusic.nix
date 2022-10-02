{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-ytmusic";
  version = "0.3.7";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-YTMusic";
    sha256 = "0gqjvi3nfzkqvbdhihzai241p1h5p037bj2475cc93xwzyyqxcrq";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.ytmusicapi
    python3Packages.pytube
  ];

  pythonImportsCheck = [ "mopidy_ytmusic" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube Music";
    homepage = "https://github.com/OzymandiasTheGreat/mopidy-ytmusic";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}
