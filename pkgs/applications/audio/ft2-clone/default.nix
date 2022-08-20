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
  version = "1.56";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    sha256 = "sha256-kSnsep6abE07Q1EpGEeX8e/2APc60TxR2MhLZxqW9WY=";
  };

  # Adapt the linux-only CMakeLists to darwin (more reliable than make-macos.sh)
  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i -e 's@__LINUX_ALSA__@__MACOSX_CORE__@' -e 's@asound@@' CMakeLists.txt
  '';

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

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin [
    "-framework CoreAudio"
    "-framework CoreMIDI"
    "-framework CoreServices"
    "-framework Cocoa"
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

