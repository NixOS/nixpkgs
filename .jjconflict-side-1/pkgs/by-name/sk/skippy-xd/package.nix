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
stdenv.mkDerivation rec {
  pname = "skippy-xd";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "felixfung";
    repo = "skippy-xd";
    rev = "30da57cb59ccf77f766718f7d533ddbe533ba241";
    hash = "sha256-YBUDbI1SHsBI/fA3f3W1sPu3wXSodMbTGvAMqOz7RCM=";
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
  meta = with lib; {
    description = "Expose-style compositing-based standalone window switcher";
    homepage = "https://github.com/felixfung/skippy-xd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
