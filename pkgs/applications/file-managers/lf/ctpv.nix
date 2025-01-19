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
  ueberzug,
}:

stdenv.mkDerivation rec {
  pname = "ctpv";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = pname;
    rev = "v${version}";
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
          ueberzug # for image files on X11
        ]
      }";
  '';

  meta = with lib; {
    description = "File previewer for a terminal";
    homepage = "https://github.com/NikitaIvanovV/ctpv";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.wesleyjrz ];
  };
}
