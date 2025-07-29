{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-KT0sYftintyaFKr+thnK+SV36Gt9BQZL/9j+u9DtzRM=";
  };

  cargoHash = "sha256-oLMUGbhN9/6U6mcjxJTLxqogwDaXWhf/gW10l37wNdY=";

  meta = with lib; {
    description = "Tool to execute Rust code carefully, with extra checking along the way";
    mainProgram = "cargo-careful";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
