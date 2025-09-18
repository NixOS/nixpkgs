{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  protoc-gen-go,
  protoc-gen-go-grpc,
  vectorscan,
}:

buildGoModule rec {
  pname = "secretscanner";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "deepfence";
    repo = "SecretScanner";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-lTUZLuEiC9xpHYWn3uv4ZtbvHX6ETsjxacjd/O0kU8I=";
  };

  vendorHash = "sha256-lB+fiSdflIYGw0hMN0a9IOtRcJwYEUPQqaeU7mAfSQs=";

  excludedPackages = [
    "./agent-plugins-grpc/proto" # No need to build submodules
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
  ];

  buildInputs = [
    vectorscan
  ];

  preBuild = ''
    # Compile proto files
    make -C agent-plugins-grpc go
  '';

  postInstall = ''
    mv $out/bin/SecretScanner $out/bin/$pname
  '';

  meta = {
    description = "Tool to find secrets and passwords in container images and file systems";
    mainProgram = "secretscanner";
    homepage = "https://github.com/deepfence/SecretScanner";
    changelog = "https://github.com/deepfence/SecretScanner/releases/tag/v${version}";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
