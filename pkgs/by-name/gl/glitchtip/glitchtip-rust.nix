{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "glitchtip-rust";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0FG+seIWqfyOG3JR0WF4ICnxMAPx9FO0JyFSB43CttU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-14j7h4TgQhTE5oihnvjAxtGZhPajuTRD4Cga8xzN9Lg=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "gt_rust" ];

  meta = {
    description = "Rust components of GlitchTip Backend";
    homepage = "https://glitchtip.com";
    changelog = "https://gitlab.com/glitchtip/glitchtip-rust/-/tags/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
      felbinger
    ];
  };
})
