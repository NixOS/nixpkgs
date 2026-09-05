{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "10.2.0";
  pname = "oxipng";

  # do not use fetchCrate (only repository includes tests)
  src = fetchFromGitHub {
    owner = "oxipng";
    repo = "oxipng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GwpXPkEkGqF55YOszXze0iZPi+sjaxtpcKpznc9CQbI=";
  };

  cargoHash = "sha256-rxb2qKS9sNM/+65YVhZ0jUvvZf8lfDJgU3ltY2Vht00=";

  # don't require qemu for aarch64-linux tests
  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    homepage = "https://github.com/oxipng/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
})
