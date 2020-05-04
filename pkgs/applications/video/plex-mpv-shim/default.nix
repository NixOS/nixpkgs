{ stdenv, buildPythonApplication, fetchFromGitHub, mpv, requests, python-mpv-jsonipc }:

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.7.16";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pnbdxaqnliwqfvv08gi7gdcvflg5vcbgk4g0fw75prgw54vnd9a";
  };

  propagatedBuildInputs = [ mpv requests python-mpv-jsonipc ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app.";
    license = licenses.mit;
  };
}
