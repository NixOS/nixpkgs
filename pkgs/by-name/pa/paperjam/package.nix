{ lib
, stdenv
, fetchgit
, qpdf
, libiconv
, libpaper
, asciidoc
,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paperjam";
  version = "1.2-unstable-2023-05-13";

  src = fetchgit {
    url = "git://git.ucw.cz/paperjam.git";
    # this is v1.2 + build fix
    rev = "65444824e308470f49b5e4f98fd1763b7da3bd24";
    hash = "sha256-AMoSiHDKbnVtmNR07sniXruVKH7p/Pl5aey4SF8aMWA=";
  };

  buildInputs = [
    qpdf
    libpaper
    asciidoc
  ] ++ lib.optional stdenv.isDarwin libiconv;

  makeFlags = [
    "PREFIX=$(out)"
    # prevent real build date which is impure
    "BUILD_DATE=\<unknown\>"
    "BUILD_COMMIT=${finalAttrs.src.rev}"
  ];

  # provide backward compatible PointerHolder, suppress deprecation warnings
  env.NIX_CFLAGS_COMPILE = "-DPOINTERHOLDER_TRANSITION=0";

  meta = {
    homepage = "https://mj.ucw.cz/sw/paperjam/";
    description = "A program for transforming PDF files";
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
