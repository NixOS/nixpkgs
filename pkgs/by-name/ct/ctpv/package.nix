{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  file,
  openssl,
  atool,
  bat,
  chafa,
  delta,
  ffmpeg,
  ffmpegthumbnailer,
  fontforge,
  glow,
  imagemagick,
  jq,
  poppler-utils,
  ueberzug,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctpv";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = "ctpv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3BQi4m44hBmPkJBFNCg6d9YKRbDZwLxdzBb/NDWTQP4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    file # libmagic
    openssl
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preFixup = ''
    wrapProgram $out/bin/ctpv \
      --prefix PATH ":" "${
        lib.makeBinPath [
          atool # for archive files
          bat
          chafa # for image files on Wayland
          delta # for diff files
          ffmpeg
          ffmpegthumbnailer
          fontforge
          glow # for markdown files
          imagemagick
          jq # for json files
          poppler-utils # for pdf files
          ueberzug # for image files on X11
        ]
      }";
  '';

  # Until https://github.com/NikitaIvanovV/ctpv/pull/90 is merged
  patches = [ ./use-polite-flag.patch ];

  meta = {
    description = "File previewer for a terminal";
    homepage = "https://github.com/NikitaIvanovV/ctpv";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.wesleyjrz ];
  };
})
