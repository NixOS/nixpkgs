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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KbITHQ9s2RUeo8zR53R9s4WUM6z8zzddz1k47So0Mlw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Extract Cell Data From Excel xls files";
    homepage = "https://github.com/libxls/libxls";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "xls2csv";
    platforms = platforms.unix;
  };
}
