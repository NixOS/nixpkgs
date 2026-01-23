{
  lib,
  stdenv,
  fetchFromGitHub,
  xorgproto,
  libX11,
  libXft,
  libXcomposite,
  libXdamage,
  libXext,
  libXinerama,
  libjpeg,
  giflib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skippy-xd";
  version = "2025.11.30";

  src = fetchFromGitHub {
    owner = "felixfung";
    repo = "skippy-xd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aN1ZJnN8xH5ggH3lknrIrz2MxrVreElUKhL8RjvZBO0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libX11
    libXft
    libXcomposite
    libXdamage
    libXext
    libXinerama
    libjpeg
    giflib
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    sed -e "s@/etc/xdg@$out&@" -i Makefile
  '';

  meta = {
    description = "Expose-style compositing-based standalone window switcher";
    homepage = "https://github.com/felixfung/skippy-xd";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
  };
})
