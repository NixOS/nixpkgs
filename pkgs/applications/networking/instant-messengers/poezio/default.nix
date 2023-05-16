{ lib
<<<<<<< HEAD
, fetchFromGitLab
, pkg-config
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "poezio";
  version = "0.13.1";
  format = "setuptools";

  src = fetchFromGitLab {
    domain = "lab.louiz.org";
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-3pUegEfhQxEv/7Htw6b2BN1lXtDockyANmi1xW4wPhA=";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
  ];

<<<<<<< HEAD
  propagatedBuildInputs = with python3.pkgs; [
=======
  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    aiodns
    cffi
    mpd2
    potr
    pyasn1
    pyasn1-modules
<<<<<<< HEAD
    pycares
    pyinotify
    slixmpp
    typing-extensions
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "poezio"
  ];

  meta = with lib; {
    description = "Free console XMPP client";
    homepage = "https://poez.io";
    changelog = "https://lab.louiz.org/poezio/poezio/-/blob/v${version}/CHANGELOG";
    license = licenses.zlib;
    maintainers = with maintainers; [ lsix ];
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
