{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libev,
  libnl,
  libpcap,
}:

stdenv.mkDerivation {
  pname = "owl";
  version = "0-unstable-2022-01-30";

  src = fetchFromGitHub {
    owner = "seemoo-lab";
    repo = "owl";
    rev = "8e4e840b212ae5a09a8a99484be3ab18bad22fa7";
    hash = "sha256-kFk+JFLGWGBu5FPH3qp/Bxa6t04f1kpeHz3H8GNF3fg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libev
    libnl
    libpcap
  ];

  postPatch = ''
    substituteInPlace googletest/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.8)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace googletest/{googlemock,googletest}/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6.4)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "Open Apple Wireless Direct Link (AWDL) implementation written in C";
    homepage = "https://owlink.org/";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "owl";
  };
}
