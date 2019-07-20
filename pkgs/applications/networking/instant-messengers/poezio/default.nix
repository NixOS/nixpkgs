{ lib, buildPythonApplication, fetchurl, pythonOlder
, pytest, aiodns, slixmpp, pyinotify, potr, mpd2, cffi, pkgconfig }:
buildPythonApplication rec {
    name = "poezio-${version}";
    version = "0.12";

    disabled = pythonOlder "3.4";

    buildInputs = [ pytest ];
    propagatedBuildInputs = [ aiodns slixmpp pyinotify potr mpd2 cffi ];
    nativeBuildInputs = [ pkgconfig ];

    src = fetchurl {
      url = "http://dev.louiz.org/attachments/download/129/${name}.tar.gz";
      sha256 = "11n9x82xyjwbqk28lsfnvqwn8qc9flv6w2c64camh6j3148ykpvz";
    };

    checkPhase = ''
      py.test
    '';

    meta = with lib; {
      description = "Free console XMPP client";
      homepage = https://poez.io;
      license = licenses.mit;
      maintainers = [ maintainers.lsix ];
    };
  }
