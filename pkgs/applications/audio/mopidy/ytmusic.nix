{ lib
, pythonPackages
, mopidy
}:

pythonPackages.buildPythonPackage rec {
  pname = "mopidy-ytmusic";
  version = "0.3.8";

  src = pythonPackages.fetchPypi {
    inherit version;
    pname = "mopidy_ytmusic";
    sha256 = "6b4d8ff9c477dbdd30d0259a009494ebe104cad3f8b37241ae503e5bce4ec2e8";
  };

  nativeBuildInputs = [ pythonPackages.pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "ytmusicapi" "pytube" ];

  propagatedBuildInputs = [
    mopidy
    pythonPackages.ytmusicapi
    pythonPackages.pytube
  ];

  pythonImportsCheck = [ "mopidy_ytmusic" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/OzymandiasTheGreat/mopidy-ytmusic/blob/v${version}/CHANGELOG.rst";
    description = "Mopidy extension for playing music from YouTube Music";
    homepage = "https://github.com/OzymandiasTheGreat/mopidy-ytmusic";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}
