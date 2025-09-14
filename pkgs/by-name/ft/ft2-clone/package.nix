{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nixosTests,
  alsa-lib,
  SDL2,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "ft2-clone";
  version = "1.98";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
    hash = "sha256-QF3BmQBmzEba9MLimwLBV9Z0XNZ6FEOidk5JE2DvGdM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux alsa-lib
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  passthru.tests = {
    ft2-clone-starts = nixosTests.ft2-clone;
  };

  meta = with lib; {
    description = "Highly accurate clone of the classic Fasttracker II software for MS-DOS";
    homepage = "https://16-bits.org/ft2.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = platforms.littleEndian;
    mainProgram = "ft2-clone";
  };
}
