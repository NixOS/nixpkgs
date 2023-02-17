{
  lib,
  stdenv,
  fetchgit,
  qpdf,
  libpaper,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paperjam";
  version = "1.2";

  src = fetchgit {
    url = "git://git.ucw.cz/paperjam.git";
    #rev = "v${finalAttrs.version}";
    # this is v1.2 + build fix
    rev = "65444824e308470f49b5e4f98fd1763b7da3bd24";
    hash = "sha256-AMoSiHDKbnVtmNR07sniXruVKH7p/Pl5aey4SF8aMWA=";
  };

  buildInputs = [
    qpdf
    libpaper
    asciidoc
  ];

  makeFlags = [
    "PREFIX=$(out)"
    # prevent real build date which is impure
    "BUILD_DATE=\\<unknown\\>"
    "BUILD_COMMIT=${finalAttrs.src.rev}"
  ];

  meta = {
    homepage = "https://mj.ucw.cz/sw/paperjam/";
    description = "A program for transforming PDF files";
    longDescription = ''
      PaperJam is a program for transforming PDF files. It can re-arrange
      pages, scale and rotate them, put multiple pages on a single sheet, draw
      cropmarks, and many other tricks.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ vojta001 ];
    platforms = lib.platforms.all;
  };
})
