{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    tag = "v${version}";
    hash = "sha256-/RfGduRfXEZO66qhKOOMpESNxBghjqf/vbg1gkCPyHM=";
  };

  vendorHash = "sha256-j5T1Ho3K0kPZOo5LA6Md06W/gF6DmEElGt9BvceBtTo=";

  subPackages = [
    "cmd/protoc-gen-connect-go"
  ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  meta = with lib; {
    description = "Simple, reliable, interoperable, better gRPC";
    mainProgram = "protoc-gen-connect-go";
    homepage = "https://github.com/connectrpc/connect-go";
    changelog = "https://github.com/connectrpc/connect-go/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kilimnik
      jk
    ];
  };
}
