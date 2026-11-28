{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sort";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "devinr528";
    repo = "cargo-sort";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jmENzRsq6BrITQbubvw+1EeB6Xclxr9H+FuGq61k6+Q=";
  };

  cargoHash = "sha256-XnllAeHV2fDsGQgegaM93C6NwhamQ4qQGa8NRGARxGA=";

  meta = {
    description = "Tool to check that your Cargo.toml dependencies are sorted alphabetically";
    mainProgram = "cargo-sort";
    homepage = "https://github.com/devinr528/cargo-sort";
    changelog = "https://github.com/devinr528/cargo-sort/blob/v${finalAttrs.version}/changelog.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
