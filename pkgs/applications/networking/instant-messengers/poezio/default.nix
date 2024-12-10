{
  lib,
  fetchFromGitLab,
  pkg-config,
  python3,
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
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiodns
    cffi
    mpd2
    potr
    pyasn1
    pyasn1-modules
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
  };
}
