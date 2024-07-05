{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
, pkg-config
,
}:
rustPlatform.buildRustPackage rec {
  pname = "kclvm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "kcl";
    rev = "v${version}";
    hash = "sha256-xVKoH0wu8QP4g/klTidx1wdt/oFoTX5GS/J9uVGgKjo=";
  };

  sourceRoot = "source/kclvm";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "inkwell-0.2.0" = "sha256-JxSlhShb3JPhsXK8nGFi2uGPp8XqZUSiqniLBrhr+sM=";
      "protoc-bin-vendored-3.1.0" = "sha256-RRqpPMJygpKGG5NYzD93iy4htpVqFhYMmfPgbRtpUqg=";
    };
  };

  nativeBuildInputs = [ pkg-config protobuf ];

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  meta = with lib; {
    description = "A high-performance implementation of KCL written in Rust that uses LLVM as the compiler backend";
    homepage = "https://github.com/kcl-lang/kcl";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ selfuryon peefy ];
  };
}
