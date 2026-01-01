{
  stdenv,
  lib,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "smemstat";
  version = "0.02.13";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "smemstat";
    rev = "V${version}";
    hash = "sha256-wxgw5tPdZAhhISbay8BwoL5zxZJV4WstDpOtv9umf54=";
  };

  buildInputs = [ ncurses ];
  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

<<<<<<< HEAD
  meta = {
    description = "Memory usage monitoring tool";
    mainProgram = "smemstat";
    homepage = "https://github.com/ColinIanKing/smemstat";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ womfoo ];
=======
  meta = with lib; {
    description = "Memory usage monitoring tool";
    mainProgram = "smemstat";
    homepage = "https://github.com/ColinIanKing/smemstat";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
