{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-xwin";
  version = "0.21.4";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mgFMjNxjB4S9/nou6S8NN8ZpXX7K49lLArt/cXcSPIE=";
  };

  cargoHash = "sha256-Md2pk8kYqUDPzRQedbne4Crg5UbGHHE5OTRz4LXLs3E=";

  meta = {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
})
