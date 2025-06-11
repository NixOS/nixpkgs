{
  lib,
  stdenv,
  fetchFromGitHub,
  libjpeg,
  libpng,
  ncurses,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  bash-completion,
  libwebp,
  libexif,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.3.2";
  pname = "jp2a";

  src = fetchFromGitHub {
    owner = "Talinx";
    repo = "jp2a";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GcwwzVgF7BK2N8TL8z/7R7Ry1e9pmGiXUrOAQQmPIBo=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    bash-completion
  ];

  buildInputs = [
    libjpeg
    libpng
    ncurses
    libwebp
    libexif
  ];

  installFlags = [ "bashcompdir=\${out}/share/bash-completion/completions" ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://csl.name/jp2a/";
    description = "Small utility that converts JPG images to ASCII";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.FlorianFranzen ];
    platforms = lib.platforms.unix;
    mainProgram = "jp2a";
  };
})
