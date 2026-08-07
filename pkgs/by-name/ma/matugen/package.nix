{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matugen";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xzwMDWb6pF3oStVoS8enNhpYptxdnB1NSIO7dUH6/qk=";
  };

  cargoHash = "sha256-bfvlPiTlPQeedo+ikHXSI8NqdA5R5M7gCsgx7srYsMQ=";

  meta = {
    description = "Material you color generation tool";
    homepage = "https://github.com/InioX/matugen";
    changelog = "https://github.com/InioX/matugen/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "matugen";
  };
})
