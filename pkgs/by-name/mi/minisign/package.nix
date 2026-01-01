{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsodium,
}:

stdenv.mkDerivation rec {
  pname = "minisign";
  version = "0.12";

  src = fetchFromGitHub {
    repo = "minisign";
    owner = "jedisct1";
    rev = version;
    sha256 = "sha256-qhAzhht9p4bsa2ntJwhcNurm8QgYYiKi3dA3ifpT8aw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ libsodium ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Simple tool for signing files and verifying signatures";
    longDescription = ''
      minisign uses public key cryptography to help facilitate secure (but not
      necessarily private) file transfer, e.g., of software artefacts. minisign
      is similar to and compatible with OpenBSD's signify.
    '';
    homepage = "https://jedisct1.github.io/minisign/";
<<<<<<< HEAD
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ joachifm ];
    platforms = lib.platforms.unix;
=======
    license = licenses.isc;
    maintainers = with maintainers; [ joachifm ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "minisign";
  };
}
