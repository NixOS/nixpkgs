{
  lib,
  buildGoModule,
  fetchFromGitHub,
  mupdf,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "lnreader";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Yujonpradhananga";
    repo = "CLI-PDF-EPUB-reader";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JeVS0wnShlD4+UfnMsuHMYi6R7pse4Gvh0PdREwmG6k=";
  };

  vendorHash = "sha256-66rqTJeV6u4aVciifp41n2onx81w9KE0PGYHlVwsl54=";

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
    mainProgram = "lnreader";
    platforms = lib.platforms.unix;
  };
})
