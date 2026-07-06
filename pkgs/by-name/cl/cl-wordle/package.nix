{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cl-wordle";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "conradludgate";
    repo = "wordle";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-wFTvzAzboUFQg3fauIwIdRChK7rmLES92jK+8ff1D3s=";
  };

  cargoHash = "sha256-kkR49UwwkpZhKvBadPTUn0D/4sRVlVJowQ1+BqtBVOs=";

  meta = {
    description = "Wordle TUI in Rust";
    homepage = "https://github.com/conradludgate/wordle";
    # repo has no license, but crates.io says it's MIT
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "wordle";
  };
})
