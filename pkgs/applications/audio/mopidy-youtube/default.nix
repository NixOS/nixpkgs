{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-youtube-${version}";

  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-youtube";
    rev = "v${version}";
    sha256 = "1si7j7m5kg0cxlhkw8s2mbnpmc9mb3l69n5sgklb1yv1s55iia6z";
  };

  propagatedBuildInputs = with pythonPackages; [ mopidy pafy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from YouTube";
    license = licenses.asl20;
    maintainers = [ maintainers.spwhitt ];
  };
}
