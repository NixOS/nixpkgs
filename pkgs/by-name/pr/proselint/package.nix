{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "proselint";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amperser";
    repo = "proselint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Oj5WY+YcngcaVjDq2xcnTeyvO7HnAhKdNE+h4fFa6zA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "uv_build>=0.7.22,<0.8.0" uv_build
  '';

  build-system = [ python3Packages.uv-build ];

  dependencies = with python3Packages; [ google-re2 ];

  # typing stubs are not needed at runtime
  pythonRemoveDeps = [ "google-re2-stubs" ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    hypothesis
    pytestCheckHook
    rstr
  ]);

  pythonImportsCheck = [ "proselint" ];

  meta = {
    description = "Linter for prose";
    mainProgram = "proselint";
    homepage = "https://github.com/amperser/proselint";
    changelog = "https://github.com/amperser/proselint/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.pbsds ];
  };
})
