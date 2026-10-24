{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "millet";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = "millet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Als+2+E5EyM7g+XYNXMnetC9uR1NXJnUEL4EBTl0qlQ=";
  };

  cargoHash = "sha256-M3b43xuUmecuWoQqOHt6TTI7Kj4FOvnOWOu9q41TGRQ=";

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
