{ stdenv, fetchFromGitHub, python2Packages, mopidy }:

python2Packages.buildPythonApplication rec {
  pname = "mopidy-youtube";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-youtube";
    rev = "v${version}";
    sha256 = "06r3ikyg2ch5n7fbn3sgj04hk6icpfpk1r856qch41995k3bbfg7";
  };

  propagatedBuildInputs = with python2Packages; [ mopidy pafy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from YouTube";
    license = licenses.asl20;
    maintainers = [ maintainers.spwhitt ];
  };
}
