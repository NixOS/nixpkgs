{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${version}";
    hash = "sha256-71kAlZKSBnROZ8wXe4kQa8nNug5/hk6NKsqHoQU5pWc=";
  };

  cargoHash = "sha256-rHTEWc3JAnsz5z+NmTb84VSXHSR6nNlb5C+n9VxvnUQ=";

  meta = with lib; {
    description = "CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    mainProgram = "cargo-temp";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    changelog = "https://github.com/yozhgoor/cargo-temp/releases/tag/${src.rev}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
