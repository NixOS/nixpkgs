{ lib, buildPythonApplication, fetchFromGitHub, mpv, requests, python-mpv-jsonipc, pystray, tkinter }:

buildPythonApplication rec {
  pname = "plex-mpv-shim";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hgv9g17dkrh3zbsx27n80yvkgix9j2x0rgg6d3qsf7hp5j3xw4r";
  };

  propagatedBuildInputs = [ mpv requests python-mpv-jsonipc pystray tkinter ];

  # does not contain tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/iwalton3/plex-mpv-shim";
    description = "Allows casting of videos to MPV via the Plex mobile and web app";
    license = licenses.mit;
  };
}
