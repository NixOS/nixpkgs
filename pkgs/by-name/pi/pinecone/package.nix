{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "pinecone";
  version = "0.11.0-unstable-2023-08-10";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "pinecone";
    rev = "ea4c33717fd74ef7d6f49490625a0fa10e3f5bbc";
    hash = "sha256-q4EFWXSkQJ2n+xAWuBxdP7nrtv3eFql9LoavWo10dfs=";
  };

  vendorHash = "sha256-+P10K7G0UwkbCGEi6sYTQSqO7LzIf/xmaHIr7v110Ao=";

  meta = with lib; {
    description = "Peer-to-peer overlay routing for the Matrix ecosystem";
    homepage = "https://matrix-org.github.io/pinecone/";
    license = licenses.asl20;
    maintainers = with maintainers; [ networkexception ];
    mainProgram = "pinecone";
  };
}
