{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-soundcloud";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-soundcloud";
    rev = "v${version}";
    sha256 = "008bx1f63507gjihfib96294igzx6gy6briq3adr8sim1ypmvw38";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ maintainers.spwhitt ];
  };
}
