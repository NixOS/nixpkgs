{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "millet";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = "millet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MHAvurglG26nRvvAknqZPROSICI/ttQm0MLPsoQyw2Y=";
  };

  cargoHash = "sha256-sJi+R67SfDshs37/uibtRHs8D3NRTUSQKfePgTWo5b4=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags = [
    "--package"
    "millet-ls"
  ];

  cargoTestFlags = [
    "--package"
    "millet-ls"
  ];

  meta = {
    description = "Language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/blob/v${finalAttrs.version}/docs/CHANGELOG.md";
    license = [
      lib.licenses.mit # or
      lib.licenses.asl20
    ];
    maintainers = [ ];
    mainProgram = "millet-ls";
  };
})
