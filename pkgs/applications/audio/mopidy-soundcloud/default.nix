{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-soundcloud-${version}";

  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-soundcloud";
    rev = "v${version}";
    sha256 = "05yvjnivj26wjish7x1xrd9l5z8i14b610a8pbifnq3cq7y2m22r";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ maintainers.spwhitt ];
  };
}
