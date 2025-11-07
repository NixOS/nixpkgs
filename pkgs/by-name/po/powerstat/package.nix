{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "powerstat";
  version = "0.04.05";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "powerstat";
    rev = "V${version}";
    hash = "sha256-KR+Nzm9uRISNuqqnlTwfQP1jvSK4lAy//zdn7M8HPLk=";
  };

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Laptop power measuring tool";
    mainProgram = "powerstat";
    homepage = "https://github.com/ColinIanKing/powerstat";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
