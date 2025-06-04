{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nixops-dns";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "nixops-dns";
    rev = "v${version}";
    hash = "sha256-d3vVm6YeQTOAE5HFSKI01L9ZqfbQKrdoLsMwHP5HulE=";
  };

  vendorHash = "sha256-3DVNjvW0AAdogpTi3GMnn92FqqOUWNdQvRBityyKwcI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/museoa/nixops-dns";
    description = "DNS server for resolving NixOps machines";
    mainProgram = "nixops-dns";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamilchm
      sorki
    ];
  };
}
