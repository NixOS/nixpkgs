{
  lib,
  fetchFromCodeberg,
  pkg-config,
  python3,
}:

python3.pkgs.buildPythonApplication (finallAttrs {
  pname = "poezio";
  version = "0.15.1";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "poezio";
    repo = "poezio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v9PpPghHf0Yi5JpK98+i2EAmohSXOhUyhY+duhICtnY=";
  };

  nativeBuildInputs = [ pkg-config ];
  build-system = [ python3.pkgs.setuptools ];

  dependencies = with python3.pkgs; [
    aiodns
    pyasn1
    pyasn1-modules
    pycares
    pyinotify
    setuptools
    slixmpp
    sphinx
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
    changelog = "https://codeberg.org/poezio/poezio/src/tag/${src.tag}/CHANGELOG";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ reylak ];
  };
})
