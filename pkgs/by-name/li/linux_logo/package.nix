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

  meta = with lib; {
    description = "Prints an ASCII logo and some system info";
    mainProgram = "linux_logo";
    homepage = "http://www.deater.net/weave/vmwprod/linux_logo";
    changelog = "https://github.com/deater/linux_logo/blob/${src.rev}/CHANGES";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
