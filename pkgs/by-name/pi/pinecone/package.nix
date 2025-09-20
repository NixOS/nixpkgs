{
  lib,
  buildGo124Module,
  fetchFromGitHub,
}:

buildGo124Module {
  pname = "pinecone";
  version = "0.11.0-unstable-2025-03-04";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "pinecone";
    rev = "b35aec69f59eb9bb8bd5a8c6be30fc276d3cce96";
    hash = "sha256-0jqvWdFjN4Kzhkv4Oe1obsKGW0i/MGEMX3ZhcxpsdxA=";
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
