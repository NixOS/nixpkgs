{
  lib,
  buildPythonPackage,
  django-vpg,
  fetchFromGitLab,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "glitchtip-rust";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "glitchtip-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XQoJJ3w1HTyOtzjnsU2OD2IkOMLUSvIf+9Xd0sF9s5E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-vXRcONfyrHCjcdfjHjpauoRTgiqcHgkBsNIS6VDPWpo=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [ django-vpg ];

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
