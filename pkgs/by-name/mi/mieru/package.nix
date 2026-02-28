{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mieru";
  version = "3.28.0";

  src = fetchFromGitHub {
    owner = "enfein";
    repo = "mieru";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xX2axFK1BBgyGlA658DOCIBI0cIXY0KTdf/SyzhkYCo=";
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
})
