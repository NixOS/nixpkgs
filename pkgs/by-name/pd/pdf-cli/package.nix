{
  lib,
  buildGoModule,
  fetchFromGitHub,
  mupdf,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "pdf-cli";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "Yujonpradhananga";
    repo = "pdf-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TvfSauT9UWjQjkzQtepEVyxm/LaiCANmxMtVmjiw8kI=";
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
    homepage = "https://github.com/Yujonpradhananga/CLI-PDF-EPUB-reader";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yujonpradhananga ];
    mainProgram = "pdf-cli";
    platforms = lib.platforms.unix;
  };
})
