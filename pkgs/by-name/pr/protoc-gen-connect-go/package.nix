{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    tag = "v${version}";
    hash = "sha256-w3zn2O5gc3cbLsHStF53t1kitXvCxCyNcR5mfcr92Sg=";
  };

  vendorHash = "sha256-j5T1Ho3K0kPZOo5LA6Md06W/gF6DmEElGt9BvceBtTo=";

  subPackages = [
    "cmd/protoc-gen-connect-go"
  ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  meta = {
    description = "Simple, reliable, interoperable, better gRPC";
    mainProgram = "protoc-gen-connect-go";
    homepage = "https://github.com/connectrpc/connect-go";
    changelog = "https://github.com/connectrpc/connect-go/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kilimnik
      jk
    ];
  };
}
