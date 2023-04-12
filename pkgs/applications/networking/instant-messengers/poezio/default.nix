{ lib
, aiodns
, buildPythonApplication
, cffi
, fetchFromGitHub
, mpd2
, pkg-config
, potr
, pyasn1
, pyasn1-modules
, pyinotify
, pytestCheckHook
, pythonOlder
, setuptools
, slixmpp
, typing-extensions
}:

buildPythonApplication rec {
  pname = "poezio";
  version = "0.13.1";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "041y61pcbdb86s04qwp8s1g6bp84yskc7vdizwpi2hz18y01x5fy";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    aiodns
    cffi
    mpd2
    potr
    pyasn1
    pyasn1-modules
    pyinotify
    setuptools
    slixmpp
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Free console XMPP client";
    homepage = "https://poez.io";
    license = licenses.zlib;
    maintainers = [ maintainers.lsix ];
  };
}
