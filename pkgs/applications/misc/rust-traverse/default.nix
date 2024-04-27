{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, zstd
, stdenv
, darwin
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

  cargoHash = "sha256-aZ0KewzeC6o+wW2EejodHnOPbuTLjRufEYGWDyoqkq0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Foundation
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Terminal based file explorer";
    homepage = "https://github.com/dmcg310/Rust-Traverse";
    changelog = "https://github.com/dmcg310/Rust-Traverse/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rt";
  };
}
