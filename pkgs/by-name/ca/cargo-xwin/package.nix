{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-xwin";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lJu/TyzKDj0yHCP83ouc6e52E48taOTQ9WpWAiqUxl4=";
  };

  cargoHash = "sha256-k3PuEjiew012+m4RRVKNOdxKvFPWIxKHgG/SrBjM2WM=";

  meta = {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
})
