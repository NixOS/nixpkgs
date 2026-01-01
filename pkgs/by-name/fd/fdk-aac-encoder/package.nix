{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  fdk_aac,
}:

stdenv.mkDerivation rec {
  pname = "fdkaac";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "nu774";
    repo = "fdkaac";
    rev = "v${version}";
    hash = "sha256-nVVeYk7t4+n/BsOKs744stsvgJd+zNnbASk3bAgFTpk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ fdk_aac ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Command line encoder frontend for libfdk-aac encoder";
    mainProgram = "fdkaac";
    longDescription = ''
      fdkaac reads linear PCM audio in either WAV, raw PCM, or CAF format,
      and encodes it into either M4A / AAC file.
    '';
    homepage = "https://github.com/nu774/fdkaac";
<<<<<<< HEAD
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.lunik1 ];
=======
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = [ maintainers.lunik1 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
