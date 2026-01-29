{
  lib,
  fetchFromGitea,
  pkg-config,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "poezio";
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "poezio";
    repo = "poezio";
    rev = "v${version}";
    hash = "sha256-v9PpPghHf0Yi5JpK98+i2EAmohSXOhUyhY+duhICtnY=";
  };

  nativeBuildInputs = [ pkg-config ];
  build-system = [ python3.pkgs.setuptools ];

  dependencies = with python3.pkgs; [
    aiodns
    cffi
    mpd2
    potr
    pyasn1
    pyasn1-modules
    pycares
    pyinotify
    setuptools
    slixmpp
    sphinx
    typing-extensions
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "poezio"
  ];

  # remove poezio directory to prevent pytest import confusion
  preCheck = ''
    rm -r poezio
  '';

  meta = {
    description = "Free console XMPP client";
    homepage = "https://poez.io";
    changelog = "https://codeberg.org/poezio/poezio/src/tag/v${version}/CHANGELOG";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ reylak ];
  };
}
