{ lib, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "1.69";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    sha256 = "sha256-tm0yTh46UKnsjH9hv3cMW0YL2x3OTRL+14x4c7w124U=";
  };

  patches = [
    # Adapt CMake script to be Darwin-compatible
    # https://github.com/8bitbubsy/ft2-clone/pull/30
    (fetchpatch {
      name = "0001-ft2-clone-Make-CMake-script-macOS-compatible.patch";
      url = "https://github.com/8bitbubsy/ft2-clone/pull/30/commits/0033a567abf7ddbdb2bc59c7f730d22f986010aa.patch";
      hash = "sha256-fhA+T6RI+Qmhr7mbG9lEA7esWskgK8+DkWzol0J2lUo=";
    })
    (fetchpatch {
      name = "0002-ft2-clone-Fix-__MACOSX_CORE__-typo.patch";
      url = "https://github.com/8bitbubsy/ft2-clone/pull/30/commits/fe50aff9233130150a6631875611c7db67a2d705.patch";
      hash = "sha256-X4AVuJ0iRlpH1N/YzjdVk5+yv7eiDNoZkk0mhOizgOg=";
    })
  ];

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

