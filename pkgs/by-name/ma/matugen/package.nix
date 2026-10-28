{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "matugen";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VbzUY/0Q44vNYa+HB5qpctSpVsnPB+aYsFsx77Ggc7I=";
  };

  cargoHash = "sha256-jmeyg1HWlRL8bdMhjqUVcd9TR6XtwP5aRGJAx4FYshw=";

  meta = {
    description = "Material you color generation tool";
    homepage = "https://github.com/InioX/matugen";
    changelog = "https://github.com/InioX/matugen/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "matugen";
  };
})
