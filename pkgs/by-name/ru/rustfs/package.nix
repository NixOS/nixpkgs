{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  openssl,
  protobuf,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfs";
  version = "1.0.0-beta.3";

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = finalAttrs.version;
    hash = "sha256-9IVXAuXfFSNM+1CMfI4OsBLYjH9fcTdXsqtpjhz2Jm0=";
  };

  cargoHash = "sha256-i6Hwr6y59CjNCm6ogO6VjVgcCtm5DrKaRMjh2h3T8zY=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    protobuf
  ];

  buildInputs = [
    openssl
  ];

  PROTOC = "${protobuf}/bin/protoc";
  RUSTFLAGS = "--cfg tokio_unstable";

  cargoBuildFlags = [
    "--package"
    "rustfs"
  ];

  doCheck = false;

  meta = {
    description = "A distributed object storage system written in Rust";
    homepage = "https://github.com/rustfs/rustfs";
    license = licenses.asl20;
    maintainers = [ maintainers.majinghe ];
    mainProgram = "rustfs";
    platforms = platforms.unix;
  };
}
