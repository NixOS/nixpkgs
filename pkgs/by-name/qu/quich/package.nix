{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "quich";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Usbac";
    repo = "quich";
    rev = "v${version}";
    sha256 = "sha256-4gsSjLZ7Z4ErNqe86Fy5IrzLMfvDyY18sE0yBnj9bvM=";
  };

  doCheck = true;

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Advanced terminal calculator";
    longDescription = ''
      Quich is a compact, fast, powerful and useful calculator for your terminal
      with numerous features, supporting Windows and Linux Systems,
      written in ANSI C.
    '';
    homepage = "https://github.com/Usbac/quich";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.xdhampus ];
    platforms = lib.platforms.all;
=======
    license = licenses.mit;
    maintainers = [ maintainers.xdhampus ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "quich";
  };
}
