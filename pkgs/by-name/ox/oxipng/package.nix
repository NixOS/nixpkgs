{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  version = "10.2.1";
  pname = "oxipng";

  # do not use fetchCrate (only repository includes tests)
  src = fetchFromGitHub {
    owner = "oxipng";
    repo = "oxipng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NWDd56sZ/7W8cq9P3o8ifjLhyR+ZHEYrh1fUbyGYhBQ=";
  };

  cargoHash = "sha256-9DD1EHNtxLN3vwJQFIdibw1SnEgKHlCZAqq7GkDSQh4=";

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
