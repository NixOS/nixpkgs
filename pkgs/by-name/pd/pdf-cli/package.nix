{
  lib,
  buildGoModule,
  fetchFromGitHub,
  mupdf,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "pdf-cli";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "Yujonpradhananga";
    repo = "pdf-cli";
    rev = "v.3.0";
    hash = "sha256-9LXnRHh1afusg4YmVqZam6efJnrW4Bxx02xbArsGIxM=";
  };

  vendorHash = "sha256-LCIv135ywuq494hZbrKdbqkGPSsSlSkVQ9hCE8i7www=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    mupdf
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Lightweight, fast and responsive terminal PDF/EPUB viewer with image support";
    homepage = "https://github.com/Yujonpradhananga/pdf-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yujonpradhananga ];
    mainProgram = "pdf-cli";
    platforms = lib.platforms.unix;
  };
})
