{ stdenv, buildPythonApplication, fetchFromGitHub, mpv, requests, python-mpv-jsonipc }:

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.7.14";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rjifqvs59w2aacfird02myqfd34qadhacj9zpy5xjz25x410zza";
  };

  propagatedBuildInputs = [ mpv requests python-mpv-jsonipc ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app.";
    license = licenses.mit;
  };
}
