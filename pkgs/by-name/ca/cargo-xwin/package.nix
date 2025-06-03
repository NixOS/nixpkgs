{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-xwin";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${version}";
    hash = "sha256-P4X7k0r29vEjsVHGOD/rFpltUF2PJHETVyazJ6c8UhQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Oq3IfaywAZPrh4oom2ejPQRTM2BsgEzfaifaLAQzvbw=";

  meta = with lib; {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
