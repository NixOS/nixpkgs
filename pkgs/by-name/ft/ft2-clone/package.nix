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
<<<<<<< HEAD
  version = "2.03";
=======
  version = "2.00";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "8bitbubsy";
    repo = "ft2-clone";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-kOSH9jEdS3wU2XAEh7fh5XIuIU7zqqWrpcBZqKEZM84=";
=======
    hash = "sha256-Wx4dOWGyQRHgTqKZrmRIiX74UIU/ltFVAh217RYwUus=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Highly accurate clone of the classic Fasttracker II software for MS-DOS";
    homepage = "https://16-bits.org/ft2.php";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = lib.platforms.littleEndian;
=======
  meta = with lib; {
    description = "Highly accurate clone of the classic Fasttracker II software for MS-DOS";
    homepage = "https://16-bits.org/ft2.php";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    # From HOW-TO-COMPILE.txt:
    # > This code is NOT big-endian compatible
    platforms = platforms.littleEndian;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ft2-clone";
  };
}
