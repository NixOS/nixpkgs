{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "csvlens";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "csvlens";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nXrgQRjQkAnSP/knIG4oemwle4U0SvaefMIfBfRDcc8=";
  };

  # skips app::tests::test_copy_selection_crlf
  # needed due https://github.com/YS-L/csvlens/issues/158
  CI = "true";

  cargoHash = "sha256-925xfgN9Y28CDSr0yZP+WcpeWK452pUrqqL0nYIYlwE=";

  meta = {
    description = "Command line csv viewer";
    homepage = "https://github.com/YS-L/csvlens";
    changelog = "https://github.com/YS-L/csvlens/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "csvlens";
  };
})
