{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  mupdf,
  djvulibre,
  libjpeg,
  poppler,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbpdf";
  version = "0-unstable-2025-01-25";

  src = fetchFromGitHub {
    owner = "aligrudi";
    repo = "fbpdf";
    rev = "6a0d77f06f6f03085a5b786d1feb8a041318b30a";
    hash = "sha256-7NlOiPaGradi+brjd5X9IjvEGbWdTTTQ+PMAx6xw0Uk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    mupdf
    djvulibre
    libjpeg
    poppler
  ];

  #nixpkg's mupdf exposes a single shared libmupdf while fbpdf's upstream
  #Makefile links against older split mupdf libraries (libmupdf-third,
  #libmupdf-pkcs7, libmupdf-threads). Patch the link flags to match
  #current nixpkgs mupdf.
  postPatch = ''
    substituteInPlace Makefile  \
      --replace-fail "-lmupdf -lmupdf-third -lmupdf-pkcs7 -lmupdf-threads -lm" "-lmupdf -lm"
  '';

  buildFlags = [
    "fbpdf"
    "fbdjvu"
    "fbpdf2"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 fbpdf $out/bin/fbpdf
    install -Dm755 fbdjvu $out/bin/fbdjvu
    install -Dm755 fbpdf2 $out/bin/fbpdf2
    installManPage fbpdf.1

    runHook postInstall
  '';

  meta = {
    description = "Linux framebuffer PDF, DjVu, EPUB, XPS, and CBZ viewer";
    homepage = "https://github.com/aligrudi/fbpdf";
    mainProgram = "fbpdf";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
