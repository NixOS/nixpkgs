{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
  dos2unix,
  gperf,
  adms,
  withAdms ? false,
}:

stdenv.mkDerivation rec {
  pname = "qucsator-rf";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "ra3xdh";
    repo = "qucsator_rf";
    rev = version;
    hash = "sha256-xJexw3ITjyQFC6hbHiu/sKu3DtC9QHtTnsJTyI5OrWQ=";
  };

  nativeBuildInputs = [
    cmake
    flex
    bison
    gperf
    dos2unix
  ];

  buildInputs = lib.optionals withAdms [ adms ];

  cmakeFlags = [
    "-DBISON_DIR=${bison}/bin"
    "-DWITH_ADMS=${if withAdms then "ON" else "OFF"}"
  ];

  meta = with lib; {
    description = "RF circuit simulation kernel for Qucs-S";
    homepage = "https://github.com/ra3xdh/qucsator_rf";
    license = licenses.gpl2;
    mainProgram = "qucsator_rf";
    maintainers = with maintainers; [ thomaslepoix ];
    platforms = with platforms; linux;
  };
}
