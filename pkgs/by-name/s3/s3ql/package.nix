{
  lib,
  fetchFromGitHub,
  python3,
  replaceVars,
  sqlite,
  which,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

let
  inherit (python3.pkgs)
    buildPythonApplication
    setuptools
    cython
    apsw
    cryptography
    defusedxml
    google-auth
    google-auth-oauthlib
    pyfuse3
    requests
    trio
    pytest-trio
    pytestCheckHook
    python
    ;
in

buildPythonApplication rec {
  pname = "s3ql";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s3ql";
    repo = "s3ql";
    tag = "s3ql-${version}";
    hash = "sha256-SVB+VB508hGXvdHZo5lt09yssjjwHS1tsDU8M4j+swc=";
  };

  patches = [
    (replaceVars ./0001-setup.py-remove-self-reference.patch { inherit version; })
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [
    which
    cython
  ];

  dependencies = [
    apsw
    cryptography
    defusedxml
    google-auth
    google-auth-oauthlib
    pyfuse3
    requests
    sqlite
    trio
  ];

  nativeCheckInputs = [
    pytest-trio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} ./setup.py build_cython build_ext --inplace
  '';

  pythonImportsCheck = [ "s3ql" ];

  enabledTestPaths = [ "tests/" ];

  # SSL EOF error doesn't match connection reset error. Seems fine.
  disabledTests = [ "test_aborted_write2" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "s3ql-([0-9.]+)"
    ];
  };

  meta = {
    description = "Full-featured file system for online data storage";
    homepage = "https://github.com/s3ql/s3ql/";
    changelog = "https://github.com/s3ql/s3ql/releases/tag/s3ql-${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rushmorem ];
    platforms = lib.platforms.linux;
  };
}
