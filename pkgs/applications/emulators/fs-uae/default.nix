{ lib
, stdenv
, fetchFromGitHub
, SDL2
, autoreconfHook
, freetype
, gettext
, glib
, gtk2
, libGL
, libGLU
, libmpeg2
, lua
, openal
, pkg-config
, zip
, zlib
}:


stdenv.mkDerivation rec {
  pname = "fs-uae";
  version = "3.1.66";

  src = fetchFromGitHub {
    owner = "FrodeSolheim";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zPVRPazelmNaxcoCStB0j9b9qwQDTgv3O7Bg3VlW9ys=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    SDL2
    freetype
    gettext
    glib
    gtk2
    libGL
    libGLU
    libmpeg2
    lua
    openal
    zip
    zlib
  ];

  meta = with lib; {
    homepage = "https://fs-uae.net";
    description = "An accurate, customizable Amiga Emulator";
    longDescription = ''
      FS-UAE integrates the most accurate Amiga emulation code available
      from WinUAE. FS-UAE emulates A500, A500+, A600, A1200, A1000, A3000
      and A4000 models, but you can tweak the hardware configuration and
      create customized Amigas.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
