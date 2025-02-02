{
  lib,
  stdenv,
  fetchFromGitHub,
  libiconv,
  zlib,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "1.4";
  pname = "runzip";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libiconv
    zlib
  ];

  src = fetchFromGitHub {
    owner = "vlm";
    repo = "zip-fix-filename-encoding";
    rev = "v${version}";
    sha256 = "0l5zbb5hswxczigvyal877j0aiq3fc01j3gv88bvy7ikyvw3lc07";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=implicit-int"
    "-Wno-error=incompatible-pointer-types"
  ];

  meta = {
    description = "Tool to convert filename encoding inside a ZIP archive";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    mainProgram = "runzip";
  };
}
