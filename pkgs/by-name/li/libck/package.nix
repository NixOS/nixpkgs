{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ck";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "concurrencykit";
    repo = "ck";
    rev = version;
    sha256 = "sha256-lxJ8WsZ3pBGf4sFYj5+tR37EYDZqpksaoohiIKA4pRI=";
  };

  postPatch = ''
    substituteInPlace \
      configure \
        --replace \
          'COMPILER=`./.1 2> /dev/null`' \
          "COMPILER=gcc"
  '';

  configureFlags = [ "--platform=${stdenv.hostPlatform.parsed.cpu.name}}" ];

  dontDisableStatic = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "High-performance concurrency research library";
    longDescription = ''
      Concurrency primitives, safe memory reclamation mechanisms and non-blocking data structures for the research, design and implementation of high performance concurrent systems.
    '';
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      bsd2
    ];
    homepage = "https://concurrencykit.org/";
<<<<<<< HEAD
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
=======
    platforms = platforms.unix;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      chessai
      thoughtpolice
    ];
  };
}
