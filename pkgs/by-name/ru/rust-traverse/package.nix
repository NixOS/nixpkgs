{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-traverse";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dmcg310";
    repo = "Rust-Traverse";
    rev = "v${version}";
    hash = "sha256-OcCWmBNDo4AA5Pk5TQqb8hen9LlHaY09Wrm4BkrU7qA=";
  };

  cargoHash = "sha256-UGPXV55+0w6QFYxfmmimSX/dleCdtEahveNi8DgSVzQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Terminal based file explorer";
    homepage = "https://github.com/dmcg310/Rust-Traverse";
    changelog = "https://github.com/dmcg310/Rust-Traverse/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "rt";
  };
}
