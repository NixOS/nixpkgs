{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "millet";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = "millet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D2USOM6KrHs3Iuim98XVI7y0/aNk+kVNXo/6rgEYoCw=";
  };

  cargoHash = "sha256-g63mDzqKY/18v3qi6KnV4qmuMRxupVVe43es/84Z/h0=";

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
