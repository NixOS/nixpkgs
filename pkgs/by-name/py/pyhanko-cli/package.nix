{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "pyhanko-cli";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "pyhanko";
    tag = "pyhanko-cli/v${version}";
    hash = "sha256-ZDHAcI2yoiVifYt05V85lz8mJmoyi10g4XoLQ+LhLHE=";
  };

  sourceRoot = "${src.name}/pkgs/pyhanko-cli";

  postPatch = ''
    substituteInPlace src/pyhanko/cli/version.py \
      --replace-fail "0.0.0.dev1" "${version}" \
      --replace-fail "(0, 0, 0, 'dev1')" "tuple(\"${version}\".split(\".\"))"
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0.dev1" "${version}"
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

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pyhanko.testData
    requests-mock
    freezegun
    certomancer
    aiohttp
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
    changelog = "https://github.com/MatthiasValvekens/pyHanko/blob/pyhanko-cli/${src.tag}/docs/changelog.rst#pyhanko-cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.antonmosich ];
  };
}
