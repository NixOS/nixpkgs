{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "grind";
  version = "0.8.1-alpha";

  src = fetchFromGitHub {
    owner = "AnharHussainMiah";
    repo = "grind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lb/tvA3W+TxuTc7DsOrYup2iD4LuyM+qwIl9T2sESyo=";
  };

  cargoHash = "sha256-CYYtJnPPGSHtZta1qcM+rabeZn4TnOVoH7fiBrz6OCM=";

  checkFlags = [
    "--skip=integrity::tests::test_integrity_on_src_directory"
  ];

  meta = {
    description = "Java builds, without the headache";
    homepage = "https://github.com/AnharHussainMiah/grind";
    downloadPage = "https://github.com/AnharHussainMiah/grind/releases";
    changelog = "https://github.com/AnharHussainMiah/grind/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      junglerobba
    ];
  };
})
