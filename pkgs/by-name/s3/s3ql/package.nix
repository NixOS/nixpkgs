{
  lib,
  fetchFromGitHub,
  python3,
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
    anyio
    apsw
    cryptography
    defusedxml
    google-auth
    google-auth-oauthlib
    h11
    httpcore
    more-itertools
    pydantic
    pyfuse3
    requests
    trio
    typer
    pytest-trio
    pytestCheckHook
    ;
in

buildPythonApplication (finalAttrs: {
  pname = "s3ql";
  version = "6.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s3ql";
    repo = "s3ql";
    tag = "s3ql-${finalAttrs.version}";
    hash = "sha256-YPp/QN5oYyTzYLfb7KJGsvEF7wTt94XwuYCjCOF3cos=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [
    which
  ];

  dependencies = [
    anyio
    apsw
    cryptography
    defusedxml
    google-auth
    google-auth-oauthlib
    h11
    httpcore
    more-itertools
    pydantic
    pyfuse3
    requests
    sqlite
    trio
    typer
  ];

  nativeCheckInputs = [
    pytest-trio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
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
    changelog = "https://github.com/s3ql/s3ql/releases/tag/s3ql-${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rushmorem ];
    platforms = lib.platforms.linux;
  };
})
