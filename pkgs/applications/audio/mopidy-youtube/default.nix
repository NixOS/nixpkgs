{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-youtube-${version}";

  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-youtube";
    rev = "v${version}";
    sha256 = "06r3ikyg2ch5n7fbn3sgj04hk6icpfpk1r856qch41995k3bbfg7";
  };

  propagatedBuildInputs = with pythonPackages; [ mopidy pafy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from YouTube";
    license = licenses.asl20;
    maintainers = [ maintainers.spwhitt ];
  };
}
