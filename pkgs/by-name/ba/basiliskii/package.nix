{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  SDL2,
  gtk2,
  mpfr,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "basiliskii";
  version = "unstable-2022-09-30";

  src = fetchFromGitHub {
    owner = "kanjitalk755";
    repo = "macemu";
    rev = "2fa17a0783cf36ae60b77b5ed930cda4dc1824af";
    sha256 = "+jkns6H2YjlewbUzgoteGSQYWJL+OWVu178aM+BtABM=";
  };
  sourceRoot = "${finalAttrs.src.name}/BasiliskII/src/Unix";
  patches = [ ./remove-redhat-6-workaround-for-scsi-sg.h.patch ];
  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];
  buildInputs = [
    SDL2
    gtk2
    mpfr
  ];
  preConfigure = ''
    NO_CONFIGURE=1 ./autogen.sh
  '';
  configureFlags = [
    "--enable-sdl-video"
    "--enable-sdl-audio"
    "--with-bincue"
  ];

  meta = with lib; {
    description = "68k Macintosh emulator";
    homepage = "https://basilisk.cebix.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ quag ];
    platforms = platforms.linux;
    mainProgram = "BasiliskII";
  };
})
