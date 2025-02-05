{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mieru";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "enfein";
    repo = "mieru";
    rev = "v${version}";
    hash = "sha256-FFV1zF/sKgIVSSTcDcuB3QWfcFKbI3RJFG9RveSVe+w=";
  };

  vendorHash = "sha256-AOtq6bGijQqpNMNZA3XeMjzKAo7tWTpdrKB6KxQsdMM=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Socks5 / HTTP / HTTPS proxy to bypass censorship";
    homepage = "https://github.com/enfein/mieru";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "mieru";
  };
}
