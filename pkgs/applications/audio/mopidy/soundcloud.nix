{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-soundcloud";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-soundcloud";
    rev = "v${version}";
    sha256 = "18wiiv4rca9vibvnc27f3q4apf8n61kbp7mdbm2pmz86qwmd47pa";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ maintainers.spwhitt ];
  };
}
