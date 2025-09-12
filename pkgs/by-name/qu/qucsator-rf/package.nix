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
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "ra3xdh";
    repo = "qucsator_rf";
    rev = version;
    hash = "sha256-ZH26+FOiBaf20Od9HVHMG8ey0z6XKBnmzUyCjAKB0eM=";
  };

  # Upstream forces NO_DEFAULT_PATH on APPLE
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '"/usr/local/opt/bison/bin/"' '"${bison}/bin"'
  '';

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
    (lib.cmakeBool "WITH_ADMS" withAdms)
  ];

  meta = {
    description = "RF circuit simulation kernel for Qucs-S";
    homepage = "https://github.com/ra3xdh/qucsator_rf";
    license = lib.licenses.gpl2Plus;
    mainProgram = "qucsator_rf";
    maintainers = with lib.maintainers; [ thomaslepoix ];
    platforms = lib.platforms.unix;
  };
}
