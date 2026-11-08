{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nixosTests,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "blint";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "owasp-dep-scan";
    repo = "blint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bNPJjH3L0r4KXrKA4nVhykRe3arKCxPZVYtPvKVwR60=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    apkinspector
    appdirs
    apsw
    ar
    custom-json-diff
    defusedxml
    email-validator
    lief
    multi-demangle
    oras
    orjson
    packageurl-python
    pydantic
    pyyaml
    rich
    symbolic
    wasm-tools
  ];

  pythonRelaxDeps = [
    "apsw"
  ];

  pythonImportsCheck = [
    "blint"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # only runs on windows and fails, obviously
    "test_demangle"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # `/bin/ls` and `/usr/lib/libgmalloc.dylib` are not available when testing
    # inside the sandbox
    "test_macho_metadata_exposes_filetype"

    # The test expects Apple's `strip`, whereas in Nixpkgs it's `llvm-strip`,
    # so the results differ and it fails
    "test_universal_binary_attributes_properties_per_slice"
  ];

  passthru.tests = { inherit (nixosTests) blint; };

  meta = {
    description = "Binary Linter to check the security properties, and capabilities in executables";
    homepage = "https://github.com/owasp-dep-scan/blint";
    changelog = "https://github.com/owasp-dep-scan/blint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "blint";
  };
})
