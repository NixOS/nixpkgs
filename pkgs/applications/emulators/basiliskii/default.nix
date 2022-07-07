{ stdenv, lib, fetchFromGitHub, autoconf, automake, pkg-config, SDL2, gtk2 }:
stdenv.mkDerivation {
  pname = "basiliskii";
  version = "unstable-2022-04-05";

  src = fetchFromGitHub {
    owner = "kanjitalk755";
    repo = "macemu";
    rev = "d4baa318e49a29d7ea5fc71a637191d6c470546f";
    sha256 = "jBKTC2fIPJ6mSkMABNxcd2ujXJ+duCXw291iz5ZmiVg=";
  };
  sourceRoot = "source/BasiliskII/src/Unix";
  patches = [ ./remove-redhat-6-workaround-for-scsi-sg.h.patch ];
  nativeBuildInputs = [ autoconf automake pkg-config ];
  buildInputs = [ SDL2 gtk2 ];
  preConfigure = ''
    NO_CONFIGURE=1 ./autogen.sh
  '';
  configureFlags = [ "--enable-sdl-video" "--enable-sdl-audio" "--with-bincue" ];

  meta = with lib; {
    description = "68k Macintosh emulator";
    homepage = "https://basilisk.cebix.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ quag ];
    platforms = platforms.linux;
  };
}
