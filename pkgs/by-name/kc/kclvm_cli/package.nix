{ lib
, rustPlatform
, fetchFromGitHub
, kclvm
}:
rustPlatform.buildRustPackage rec {
  pname = "kclvm_cli";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-nk5oJRTBRj0LE2URJqno8AoZ+/342C2tEt8d6k2MAc8=";
  };

  sourceRoot = "source/cli";
  cargoLock.lockFile = ./Cargo.lock;
  cargoPatches = [ ./cargo_lock.patch ];

  buildInputs = [ kclvm ];

  meta = with lib; {
    description = "A high-performance implementation of KCL written in Rust that uses LLVM as the compiler backend";
    homepage = "https://github.com/kcl-lang/kcl";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ selfuryon peefy ];
    mainProgram = "kclvm_cli";
  };
}
