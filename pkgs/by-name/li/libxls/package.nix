{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
}:

stdenv.mkDerivation rec {
  pname = "libxls";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "libxls";
    repo = "libxls";
    rev = "v${version}";
    hash = "sha256-KbITHQ9s2RUeo8zR53R9s4WUM6z8zzddz1k47So0Mlw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Extract Cell Data From Excel xls files";
    homepage = "https://github.com/libxls/libxls";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ abbradar ];
    mainProgram = "xls2csv";
    platforms = lib.platforms.unix;
  };
}
