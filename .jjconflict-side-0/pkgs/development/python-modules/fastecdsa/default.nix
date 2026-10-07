{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  nix-update-script,
  parameterized,
  pytest-cov-stub,
  pytestCheckHook,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastecdsa";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AntonKueltz";
    repo = "fastecdsa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LZVFcobDZAHobQChkCJGlkB3UcolIDAmFGpBG4El6nw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-f0XeCUQnj+k+/NANeCs9cvuFKUiYY0mlMgAkWYpr87o=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [
    parameterized
    pytest-cov-stub
    pytestCheckHook
  ];

  preCheck = ''
    cp $out/lib/python*/site-packages/fastecdsa/*.so fastecdsa/
  '';

  pythonImportsCheck = [ "fastecdsa" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for fast elliptic curve crypto";
    homepage = "https://github.com/AntonKueltz/fastecdsa";
    changelog = "https://github.com/AntonKueltz/fastecdsa/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      cc0
      unlicense
    ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
