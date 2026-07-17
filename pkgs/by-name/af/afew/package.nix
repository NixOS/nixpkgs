{
  lib,
  python3Packages,
  fetchPypi,
  pkgs,
  testers,
  afew,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "afew";
  version = "4.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-LPKSD4aMAREtf5Y4A9oa6Sh5lv/uuLpamcP35SBgA/M=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
  ];

  nativeBuildInputs = [
    python3Packages.sphinxHook
  ];

  sphinxBuilders = [
    "html"
    "man"
  ];

  dependencies = [
    python3Packages.chardet
    python3Packages.dkimpy
    python3Packages.notmuch2
  ];

  nativeCheckInputs = [
    pkgs.notmuch
  ]
  ++ (with python3Packages; [
    freezegun
    pytestCheckHook
  ]);

  makeWrapperArgs = [
    ''--prefix PATH ':' "${pkgs.notmuch}/bin"''
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = afew;
    };
  };

  meta = {
    homepage = "https://github.com/afewmail/afew";
    description = "Initial tagging script for notmuch mail";
    mainProgram = "afew";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ flokli ];
  };
})
