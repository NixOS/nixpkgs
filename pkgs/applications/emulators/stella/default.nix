{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "stella";
  version = "6.6";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = pname;
    rev = version;
    hash = "sha256-+ZvSCnnoKGyToSFqUQOArolFdgUcBBFNjFw8aoVDkYI=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    SDL2
  ];

  meta = with lib;{
    homepage = "https://stella-emu.github.io/";
    description = "An open-source Atari 2600 VCS emulator";
    longDescription = ''
      Stella is a multi-platform Atari 2600 VCS emulator released under the GNU
      General Public License (GPL). Stella was originally developed for Linux by
      Bradford W. Mott, and is currently maintained by Stephen Anthony. Since
      its original release several people have joined the development team to
      port Stella to other operating systems such as AcornOS, AmigaOS, DOS,
      FreeBSD, IRIX, Linux, OS/2, MacOS, Unix, and Windows. The development team
      is working hard to perfect the emulator and we hope you enjoy our effort.

      As of its 3.5 release, Stella is officially donationware.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
