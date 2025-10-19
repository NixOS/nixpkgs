{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-connect-go";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    tag = "v${version}";
    hash = "sha256-pxG2f54m01tC9YhpN9zQ8M5KiP4gyt019klqnBPHHrw=";
  };

  vendorHash = "sha256-oAcAE9t4mz0HrkqO8lh5Ex2nakKj5FKy2lKTP8X/9Gg=";

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
