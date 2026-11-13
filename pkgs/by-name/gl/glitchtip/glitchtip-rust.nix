{
  lib,
  aws-lc,
  buildPythonPackage,
  django-vpg,
  fetchFromGitLab,
  pkg-config,
  rustPlatform,
  zstd,
}:

buildPythonPackage (finalAttrs: {
  pname = "glitchtip-rust";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m3MgInmxcDW/kB9EfbpmrM7pWzw/RlmEpoRQwcmWGdQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-BcAoRg1JStwMleGoSE214cbHMjIg1v62Q+TYooWzS5Y=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    aws-lc
    zstd
  ];

  dependencies = [ django-vpg ];

  pythonImportsCheck = [ "gt_rust" ];

  meta = {
    description = "Rust components of GlitchTip Backend";
    homepage = "https://glitchtip.com";
    changelog = "https://gitlab.com/glitchtip/glitchtip-rust/-/tags/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felbinger
    ];
  };
})
