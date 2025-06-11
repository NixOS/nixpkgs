{
  lib,
  stdenv,
  fetchurl,
  qpdf,
  libiconv,
  libpaper,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paperjam";
  version = "1.2.1";

  src = fetchurl {
    url = "https://mj.ucw.cz/download/linux/paperjam-${finalAttrs.version}.tar.gz";
    hash = "sha256-vTjtNTkBHwfoRDshmFu1zZfGVuEtk2NXH5JdA5Ekg5s=";
  };

  buildInputs = [
    qpdf
    libpaper
    asciidoc
  ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  makeFlags = [
    "PREFIX=$(out)"
    # prevent real build date which is impure
    "BUILD_DATE=\\<unknown\\>"
    "BUILD_COMMIT=\\<unknown\\>"
  ];

  # provide backward compatible PointerHolder, suppress deprecation warnings
  env.NIX_CFLAGS_COMPILE = "-DPOINTERHOLDER_TRANSITION=1";
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-liconv";

  meta = {
    homepage = "https://mj.ucw.cz/sw/paperjam/";
    description = "Program for transforming PDF files";
    longDescription = ''
      PaperJam is a program for transforming PDF files. It can re-arrange
      pages, scale and rotate them, put multiple pages on a single sheet, draw
      cropmarks, and many other tricks.
    '';
    license = lib.licenses.gpl2Plus;
    mainProgram = "paperjam";
    maintainers = with lib.maintainers; [ cbley ];
    platforms = lib.platforms.all;
  };
})
