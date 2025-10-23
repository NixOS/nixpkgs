{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "afetch";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "13-CF";
    repo = "afetch";
    tag = "v${version}";
    sha256 = "sha256-bHP3DJpgh89AaCX4c1tQGaZ/PiWjArED1rMdszFUq+U=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Fetch program written in C";
    homepage = "https://github.com/13-CF/afetch";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      jk
    ];
    platforms = lib.platforms.linux;
    mainProgram = "afetch";
  };
}
