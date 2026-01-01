{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "shc";
  version = "4.0.3";
  rev = version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "neurobin";
    repo = "shc";
    sha256 = "0bfn404plsssa14q89k9l3s5lxq3df0sny5lis4j2w75qrkqx694";
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://neurobin.org/projects/softwares/unix/shc/";
    description = "Shell Script Compiler";
    mainProgram = "shc";
    platforms = lib.platforms.all;
<<<<<<< HEAD
    license = lib.licenses.gpl3;
=======
    license = licenses.gpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
