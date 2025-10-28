{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-limit";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "alopatindev";
    repo = "cargo-limit";
    tag = version;
    sha256 = "sha256-joWDB9fhCsYVZFZdr+Gfm4JaRlm5kj+CHp34Sx5iQYk=";
  };

  cargoHash = "sha256-+qXw4svnftjVL7STl1mPfJiYQQkmitHsNm1JT+0HSEk=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Cargo subcommand \"limit\": reduces the noise of compiler messages";
    homepage = "https://github.com/alopatindev/cargo-limit";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      otavio
      matthiasbeyer
    ];
  };
}
