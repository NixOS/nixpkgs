{ lib, buildPythonApplication, fetchFromGitHub, pythonOlder
, pytest, aiodns, slixmpp, pyinotify, potr, mpd2, cffi, pkgconfig }:
buildPythonApplication rec {
    pname = "poezio";
    version = "0.12.1";

    disabled = pythonOlder "3.4";

    checkInputs = [ pytest ];
    propagatedBuildInputs = [ aiodns slixmpp pyinotify potr mpd2 cffi ];
    nativeBuildInputs = [ pkgconfig ];

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      sha256 = "04qnsr0l12i55k6xl4q4akx317gai9wv5f1wpkfkq01wp181i5ll";
    };

    checkPhase = ''
      pytest
    '';

    meta = with lib; {
      description = "Free console XMPP client";
      homepage = https://poez.io;
      license = licenses.mit;
      maintainers = [ maintainers.lsix ];
    };
  }
