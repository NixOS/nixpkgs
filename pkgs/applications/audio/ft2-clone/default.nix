{ lib, stdenv
, fetchFromGitHub
, cmake
, nixosTests
, alsa-lib
, SDL2
, libiconv
, CoreAudio
, CoreMIDI
, CoreServices
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "ft2-clone";
  version = "1.72.1";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    hash = "sha256-dGoldr0JvXri4XfSn/DKeJw/wsBaj+AKoKWdbEgo8lg=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 ]
    ++ lib.optional stdenv.isLinux alsa-lib
    ++ lib.optionals stdenv.isDarwin [
         libiconv
         CoreAudio
         CoreMIDI
         CoreServices
         Cocoa
       ];

  passthru.tests = {
    ft2-clone-starts = nixosTests.ft2-clone;
  };

  meta = with lib; {
    description = "A highly accurate clone of the classic Fasttracker II software for MS-DOS";
    homepage = "https://16-bits.org/ft2.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = platforms.littleEndian;
  };
}
