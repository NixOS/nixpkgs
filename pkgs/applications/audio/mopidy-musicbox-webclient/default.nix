{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-musicbox-webclient-${version}";

  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "pimusicbox";
    repo = "mopidy-musicbox-webclient";
    rev = "v${version}";
    sha256 = "0v09wy40ipl0b0dpgmcdl15c5g732c9jl7zipm4sy4pr8xiy6baa";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ maintainers.spwhitt ];
  };
}
