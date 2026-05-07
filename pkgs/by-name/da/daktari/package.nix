{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "daktari";
  version = "0.0.319";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "genio-learn";
    repo = "daktari";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NxTDyul1BESr/fBow9hwmTLr6jcl4p5RlIKNzFbaJvc=";
  };

  patches = [ ./optional-pyclip.patch ];

  pythonRelaxDeps = true;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # pyclip is broken on macOS in nixpkgs
    substituteInPlace requirements.txt --replace-fail "pyclip==0.7.0" ""
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      ansicolors
      distro
      pyfiglet
      importlib-resources
      packaging
      requests
      responses
      semver
      python-hosts
      pyyaml
      types-pyyaml
      requests-unixsocket
      dpath
      pyopenssl
      types-pyopenssl
      urllib3
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pyclip
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      pyobjc-core
      pyobjc-framework-Cocoa
    ];

  pythonImportsCheck = [ "daktari" ];

  meta = {
    description = "Tool to assist in setting up and maintaining developer environments";
    homepage = "https://github.com/genio-learn/daktari";
    changelog = "https://github.com/genio-learn/daktari/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tymscar ];
    mainProgram = "daktari";
  };
})
