{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${version}";
    hash = "sha256-fy4bG+UoN/51hiveYecl3ciJPV1g8/fC2dTFnUJZqAY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-E7msh553ijldpVI2OJ6PL0Wp+Z4eLbv8Oexl7NtBdYc=";

  meta = with lib; {
    description = "CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    mainProgram = "cargo-temp";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    changelog = "https://github.com/yozhgoor/cargo-temp/releases/tag/${src.rev}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
