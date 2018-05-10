{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-soundcloud-${version}";

  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-soundcloud";
    rev = "v${version}";
    sha256 = "13n44975n1wwcf7qg1c7drc2bavhjnr9hnq1v0n5hdgyx8ji67gi";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ maintainers.spwhitt ];
  };
}
