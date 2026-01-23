{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mieru";
  version = "3.21.0";

  src = fetchFromGitHub {
    owner = "enfein";
    repo = "mieru";
    rev = "v${version}";
    hash = "sha256-9e2V+WwcBp16DsMf31IzANdMlc/r3KFDYjSCKvKKGwM=";
  };

  vendorHash = "sha256-pKcdvP38fZ2KFYNDx6I4TfmnnvWKzFDvz80xMkUojqM=";
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
