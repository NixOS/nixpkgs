{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-connect-go";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "connectrpc";
    repo = "connect-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pv4BHVxLKpqWPaAk6uhB9WaLAOU2RkozY9My9p4EhpU=";
  };

  vendorHash = "sha256-0XmH9V7Bbuzj//87Ev6KRy6ijsgh7K6JRhhM5WY7K38=";

  subPackages = [
    "cmd/protoc-gen-connect-go"
  ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  checkFlags =
    let
      skippedTests = [
        # other tests work, could be related to sandboxing or timings
        # got:  unavailable
        # want: deadline_exceeded
        # client_ext_test.go:789: actual receive error from /connect.ping.v1.PingService/Sum: unavailable: io: read/write on closed pipe
        "TestClientDeadlineHandling/read-write"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Simple, reliable, interoperable, better gRPC";
    mainProgram = "protoc-gen-connect-go";
    homepage = "https://github.com/connectrpc/connect-go";
    changelog = "https://github.com/connectrpc/connect-go/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kilimnik
      jk
    ];
  };
})
