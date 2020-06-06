{ lib, buildPythonApplication, fetchFromGitHub, pythonOlder
, pytest, aiodns, slixmpp, pyinotify, potr, mpd2, cffi, pkgconfig, setuptools }:
buildPythonApplication rec {
    pname = "poezio";
    version = "0.13";

    disabled = pythonOlder "3.4";

    checkInputs = [ pytest ];
    propagatedBuildInputs = [ aiodns slixmpp pyinotify potr mpd2 cffi setuptools ];
    nativeBuildInputs = [ pkgconfig ];

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      sha256 = "14ig7va0yf5wdhi8hk00f1wni8pj37agggdnvsicvcw2rz1cdw0x";
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
