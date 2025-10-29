{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "mbusd";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "3cky";
    repo = "mbusd";
    rev = "v${version}";
    hash = "sha256-RQRSqlbPwBhw0SiNSP+euMVAwVBJo3lx0qB5gyWA+cM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Modbus TCP to Modbus RTU (RS-232/485) gateway";
    homepage = "https://github.com/3cky/mbusd";
    changelog = "https://github.com/3cky/mbusd/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
    mainProgram = "mbusd";
  };
}
