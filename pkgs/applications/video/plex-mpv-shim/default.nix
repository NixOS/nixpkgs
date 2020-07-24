{ stdenv, buildPythonApplication, fetchFromGitHub, mpv, requests, python-mpv-jsonipc }:

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fi0glnl7nr6754r9jk7d7dsnjbdm7civvhcj2l009yxiv2rxzj3";
  };

  propagatedBuildInputs = [ mpv requests python-mpv-jsonipc ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app.";
    license = licenses.mit;
  };
}
