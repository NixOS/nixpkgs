{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  libiconv,
  ncurses,
  perl,
  fortune,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtypist";
  version = "2.10.1";

  src = fetchurl {
    url = "mirror://gnu/gtypist/gtypist-${finalAttrs.version}.tar.xz";
    hash = "sha256-ymGAVOkfHtXvBD/MQ1ALutcByVnDGETUaI/yKEmsJS0=";
  };

  CFLAGS = "-std=gnu99";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    ncurses
    perl
    fortune
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  preFixup = ''
    wrapProgram "$out/bin/typefortune" \
      --prefix PATH : "${fortune}/bin" \
  '';

  meta = {
    homepage = "https://www.gnu.org/software/gtypist";
    description = "Universal typing tutor";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
