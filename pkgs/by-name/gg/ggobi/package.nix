{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libxml2,
  gtk2,
  autoconf,
  automake,
  libtool,
  texliveFull,
}:

stdenv.mkDerivation rec {
  version = "2.1.12-unstable-2024-06-29";
  pname = "ggobi";

  src = fetchFromGitHub {
    owner = "ggobi";
    repo = "ggobi";
    rev = "93a7148305778eb89bb838ea1b3228685a956f33";
    hash = "sha256-pVzj4Q/FAGGPTt+b8U9GAock32XYBQW+HUWNHuBZiUE=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    texliveFull
  ];
  buildInputs = [
    libxml2
    libtool
    gtk2
  ];

  configureFlags = [ "--with-all-plugins" ];

  hardeningDisable = [ "format" ];
  preConfigure = ''
    ./bootstrap
  '';

  meta = with lib; {
    description = "Visualization program for exploring high-dimensional data";
    homepage = "http://www.ggobi.org/";
    license = licenses.cpl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.michelk ];
    mainProgram = "ggobi";
  };
}
