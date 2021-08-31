{ lib, buildPythonApplication, fetchFromGitHub, mpv, requests, python-mpv-jsonipc }:

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ql7idkm916f1wlkqxqmq1i2pc94gbgq6pvb8szhb21icyy5d1y0";
  };

  propagatedBuildInputs = [ mpv requests python-mpv-jsonipc ];

  # does not contain tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app";
    license = licenses.mit;
  };
}
