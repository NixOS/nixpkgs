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

  nativeBuildInputs = with python3Packages; [
    sphinxHook
    setuptools
    setuptools-scm
  ];

  sphinxBuilders = [
    "html"
    "man"
  ];

  propagatedBuildInputs = with python3Packages; [
    chardet
    dkimpy
    notmuch2
    setuptools
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
