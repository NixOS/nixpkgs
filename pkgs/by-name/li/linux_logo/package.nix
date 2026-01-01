{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  which,
}:

stdenv.mkDerivation rec {
  pname = "linux_logo";
  version = "6.01";

  src = fetchFromGitHub {
    owner = "deater";
    repo = "linux_logo";
    rev = "v${version}";
    hash = "sha256-yBAxPwgKyFFIX0wuG7oG+FbEDpA5cPwyyJgWrFErJ7I=";
  };

  nativeBuildInputs = [
    gettext
    which
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Prints an ASCII logo and some system info";
    mainProgram = "linux_logo";
    homepage = "http://www.deater.net/weave/vmwprod/linux_logo";
    changelog = "https://github.com/deater/linux_logo/blob/${src.rev}/CHANGES";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
