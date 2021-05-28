{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-musicbox-webclient";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "pimusicbox";
    repo = "mopidy-musicbox-webclient";
    rev = "v${version}";
    sha256 = "0784s32pap9rbki3f0f7swaf6946sdv4xzidns13jmw9ilifk5z4";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ maintainers.spwhitt ];
  };
}
