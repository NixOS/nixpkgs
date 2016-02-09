{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonPackage rec {
  name = "mopidy-musicbox-webclient-${version}";

  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "pimusicbox";
    repo = "mopidy-musicbox-webclient";
    rev = "v${version}";
    sha256 = "0gnw6jn55jr6q7bdp70mk3cm5f6jy8lm3s7ayfmisihhjbl3rnaq";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ maintainers.spwhitt ];
  };
}
