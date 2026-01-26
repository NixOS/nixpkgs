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

stdenv.mkDerivation (finalAttrs: {
  pname = "ft2-clone";
  version = "2.03";

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kOSH9jEdS3wU2XAEh7fh5XIuIU7zqqWrpcBZqKEZM84=";
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

  meta = {
    description = "Highly accurate clone of the classic Fasttracker II software for MS-DOS";
    homepage = "https://16-bits.org/ft2.php";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = lib.platforms.littleEndian;
    mainProgram = "ft2-clone";
  };
})
