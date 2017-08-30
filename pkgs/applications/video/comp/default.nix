{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, youtube-dl, mpv }:

buildPythonPackage rec {
  name = "comp-${version}";
  version = "0.3.12";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "McSinyx";
    repo = "comp";
    rev = "${version}";
    sha256 = "0wrkhgyd0q20pl5s0agk8dmcb38lnpy36g0wln0r28k2h86lkz01";
  };

  propagatedBuildInputs = [ youtube-dl mpv ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Command-line YouTube player";
    homepage = src.meta.homepage;
    license = licenses.agpl3;
  };
}
