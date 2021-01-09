{ stdenv, buildPythonApplication, fetchFromGitHub, mpv, requests, python-mpv-jsonipc }:

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "06i6pp4jg0f9h6ash60fj1l5mbsdw3zyx7c6anbsrn86802i7paa";
  };

  propagatedBuildInputs = [ mpv requests python-mpv-jsonipc ];

  # does not contain tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app";
    license = licenses.mit;
  };
}
