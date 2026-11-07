{
  lib,
  python3Packages,
  fetchPypi,
  pkgs,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "afew";
  version = "4.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-gsfqyoVD6CXXd14MiyA5nq0e7wE6yymW9Ssmxpu6+E4=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
  ];

  nativeBuildInputs = [
    python3Packages.sphinxHook
  ];

  sphinxRoot = "docs";
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
    versionCheckHook
  ]
  ++ (with python3Packages; [
    freezegun
    pytestCheckHook
  ]);

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${pkgs.notmuch}/bin"
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  # Workaround for upstream packaging paths, can be removed once #573479 is resolved
  postInstall = ''
    sphinx-build -b man docs docs/build/man
    install -Dm644 docs/build/man/*.1 -t $man/share/man/man1/
  '';

  meta = {
    homepage = "https://github.com/afewmail/afew";
    description = "Initial tagging script for notmuch mail";
    mainProgram = "afew";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ flokli ];
  };
})
