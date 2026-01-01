{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "cp437";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "keaston";
    repo = "cp437";
    rev = "v${version}";
    sha256 = "18f4mnfnyviqclbhmbhix80k823481ypkwbp26qfvhnxdgzbggcc";
  };

  installPhase = ''
    install -Dm755 cp437 -t $out/bin
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = ''
      Emulates an old-style "code page 437" / "IBM-PC" character
      set terminal on a modern UTF-8 terminal emulator
    '';
    homepage = "https://github.com/keaston/cp437";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jb55 ];
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "cp437";
  };
}
