{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  SDL2,
  gtk3,
  mpfr,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "basiliskii";
  version = "unstable-2025-07-16";

  # This src is also used to build pkgs/os-specific/linux/sheep-net
  # Therefore changes to it may effect the sheep-net package
  src = fetchFromGitHub {
    owner = "kanjitalk755";
    repo = "macemu";
    rev = "030599cf8d31cb80afae0e1b086b5706dbdd2eea";
    sha256 = "sha256-gxaj+2ymelH6uWmjMLXi64xMNrToo6HZcJ7RW7sVMzo=";
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
    gtk3
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
