{ lib
, rustPlatform
, fetchFromGitHub
, kclvm
}:
rustPlatform.buildRustPackage rec {
  pname = "kclvm_cli";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-xVKoH0wu8QP4g/klTidx1wdt/oFoTX5GS/J9uVGgKjo=";
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
