{ stdenv, buildPythonApplication, fetchFromGitHub, mpv, requests }:

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xcwzmfhz22vh62wb2fz41pfl1r7h8jqlvzimbk7h9fr9x0h7vmh";
  };

  propagatedBuildInputs = [ mpv requests ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app.";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
