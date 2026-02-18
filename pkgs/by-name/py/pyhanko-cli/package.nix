{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyhanko-cli";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyhanko";
    tag = "pyhanko-cli/v${finalAttrs.version}";
    hash = "sha256-UyJ9odchy63CcCkJVtBgraRQuD2fxqCciwLuhN4+8aw=";
  };

  sourceRoot = "${finalAttrs.src.name}/pkgs/pyhanko-cli";

  postPatch = ''
    substituteInPlace src/pyhanko/cli/version.py \
      --replace-fail "0.0.0.dev1" "${finalAttrs.version}" \
      --replace-fail "(0, 0, 0, 'dev1')" "tuple(\"${finalAttrs.version}\".split(\".\"))"
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0.dev1" "${finalAttrs.version}"
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies =
    with python3Packages;
    [
      asn1crypto
      tzlocal
      pyhanko
      pyhanko-certvalidator
      click
      platformdirs
    ]
    ++ lib.concatAttrValues pyhanko.optional-dependencies;

  nativeCheckInputs = [
    versionCheckHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    pyhanko.testData
    requests-mock
    freezegun
    certomancer
    aiohttp
  ]);

  disabledTestPaths = [
    # ImportError: cannot import name 'SOFTHSM' from 'test_utils.signing_commons'
    "tests/test_cli_signing_pkcs11.py"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=pyhanko-cli/v(.*)"
    ];
  };

  meta = {
    description = "Sign and stamp PDF files";
    mainProgram = "pyhanko";
    homepage = "https://github.com/MatthiasValvekens/pyHanko/tree/master/pkgs/pyhanko-cli";
    changelog = "https://github.com/MatthiasValvekens/pyHanko/blob/pyhanko-cli/${finalAttrs.src.tag}/docs/changelog.rst#pyhanko-cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.antonmosich ];
  };
})
