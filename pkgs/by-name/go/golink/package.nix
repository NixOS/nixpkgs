{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "golink";
  version = "0-unstable-2024-01-26";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "golink";
    # https://github.com/tailscale/golink/issues/104
    rev = "d9de913fb174ec2569a15b6e2dbe5cb6e4a0a853";
    hash = "sha256-w6jRbajEQkOrBqxDnQreSmSB5DNL9flWjloShiIBM+M=";
  };

  vendorHash = "sha256-R/o3csZC/M9nm0k5STL7AhbG5J4LtdxqKaVjM/9ggW8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A private shortlink service for tailnets";
    homepage = "https://github.com/tailscale/golink";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "golink";
  };
}
