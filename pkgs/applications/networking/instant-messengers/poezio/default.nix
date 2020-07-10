{ lib, buildPythonApplication, fetchFromGitHub, pythonOlder
, pytest, aiodns, slixmpp, pyinotify, potr, mpd2, cffi, pkgconfig, setuptools }:
buildPythonApplication rec {
    pname = "poezio";
    version = "0.13.1";

    disabled = pythonOlder "3.4";

    checkInputs = [ pytest ];
    propagatedBuildInputs = [ aiodns slixmpp pyinotify potr mpd2 cffi setuptools ];
    nativeBuildInputs = [ pkgconfig ];

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      sha256 = "041y61pcbdb86s04qwp8s1g6bp84yskc7vdizwpi2hz18y01x5fy";
    };

    checkPhase = ''
      pytest
    '';

    meta = with lib; {
      description = "Free console XMPP client";
      homepage = "https://poez.io";
      license = licenses.mit;
      maintainers = [ maintainers.lsix ];
    };
  }
