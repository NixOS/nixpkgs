{
  lib,
  stdenv,
  fetchFromGitHub,
  libzip,
  libiconv,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "1.4";
  pname = "runzip";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libiconv
    libzip
  ];

  src = fetchFromGitHub {
    owner = "vlm";
    repo = "zip-fix-filename-encoding";
    rev = "v${version}";
    sha256 = "0l5zbb5hswxczigvyal877j0aiq3fc01j3gv88bvy7ikyvw3lc07";
  };

  meta = with lib; {
    description = "Tool to convert filename encoding inside a ZIP archive";
    license = licenses.bsd2;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    mainProgram = "runzip";
  };
}
