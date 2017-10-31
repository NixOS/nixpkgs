{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-musicbox-webclient-${version}";

  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "pimusicbox";
    repo = "mopidy-musicbox-webclient";
    rev = "v${version}";
    sha256 = "1jcfrwsi7axiph3jplqzmcqia9pc46xb2yf13d8h6lnh3h49rwvz";
  };

  propagatedBuildInputs = [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for playing music from SoundCloud";
    license = licenses.mit;
    maintainers = [ maintainers.spwhitt ];
  };
}
