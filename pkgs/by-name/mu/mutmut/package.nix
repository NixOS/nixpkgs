{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mutmut";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "mutmut";
    owner = "boxed";
    tag = finalAttrs.version;
    hash = "sha256-uPNPnGbCwPIlKjdvNUbClhkdKVoi2gSNBoP4xcb1AeI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail \
      'uv_build>=0.12.3,<1' 'uv_build'
  '';

  build-system = [ python3Packages.uv-build ];

  dependencies = [
    python3Packages.click
    python3Packages.parso
    python3Packages.junit-xml
    python3Packages.setproctitle
    python3Packages.textual
    python3Packages.coverage
    python3Packages.libcst
    python3Packages.pytest
  ];

  pythonImportsCheck = [ "mutmut" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mutation testing system for Python, with a strong focus on ease of use";
    mainProgram = "mutmut";
    homepage = "https://github.com/boxed/mutmut";
    changelog = "https://github.com/boxed/mutmut/blob/${finalAttrs.version}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.l0b0
    ];
  };
})
