{ stdenv, buildPythonApplication, fetchFromGitHub, mpv, requests, python-mpv-jsonipc }:

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.7.12";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l13g4vkvcd1q4lkdkbgv4hgkx5pql6ym2fap35581z7rzy9jhkq";
  };

  propagatedBuildInputs = [ mpv requests python-mpv-jsonipc ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app.";
    license = licenses.mit;
  };
}
