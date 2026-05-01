{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-limit";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "alopatindev";
    repo = "cargo-limit";
    tag = finalAttrs.version;
    sha256 = "sha256-joWDB9fhCsYVZFZdr+Gfm4JaRlm5kj+CHp34Sx5iQYk=";
  };

  cargoHash = "sha256-+qXw4svnftjVL7STl1mPfJiYQQkmitHsNm1JT+0HSEk=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cargo subcommand \"limit\": reduces the noise of compiler messages";
    homepage = "https://github.com/alopatindev/cargo-limit";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      otavio
      matthiasbeyer
    ];
  };
})
