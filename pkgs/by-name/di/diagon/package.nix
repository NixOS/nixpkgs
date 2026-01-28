{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  boost186,
  cmake,
  jdk,
}:

let

  antlr = fetchFromGitHub {
    owner = "antlr";
    repo = "antlr4";
    rev = "4.13.2";
    hash = "sha256-DxxRL+FQFA+x0RudIXtLhewseU50aScHKSCDX7DE9bY=";
  };

  antlr-jar = fetchurl {
    url = "http://www.antlr.org/download/antlr-4.13.2-complete.jar";
    hash = "sha256-6uLfoRmmQydERnKv9j6ew1ogGA3FuAkLemq4USXfTXY=";
  };

  json = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "nlohmann_json_cmake_fetchcontent";
    rev = "v3.9.1";
    hash = "sha256-5A18zFqbgDc99pqQUPcpwHi89WXb8YVR9VEwO18jH2I=";
  };

  kgt = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "kgt";
    rev = "56c3f46cf286051096d9295118c048219fe0d776";
    hash = "sha256-xH0htDZd2UihLn7PHKLjEYETzcBSeJFOMNredTqlCW8=";
  };

in
stdenv.mkDerivation rec {
  pname = "diagon";
  version = "1.1.158";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "Diagon";
    rev = "v${version}";
    hash = "sha256-Qxk3+1T0IPmvB5v3jaqvBnESpss6L8bvoW+R1l5RXdQ=";
  };

  nativeBuildInputs = [
    cmake
    jdk
  ];

  buildInputs = [
    boost186
  ];

  cmakeBuildDir = "build";
  preConfigure = ''
    mkdir -p $cmakeBuildDir
    ln -s ${antlr-jar} $cmakeBuildDir/antlr.jar
  '';

  cmakeFlags = [
    "-DCMAKE_POLICY_DEFAULT_CMP0169=OLD"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DFETCHCONTENT_SOURCE_DIR_JSON=${json}"
    "-DFETCHCONTENT_SOURCE_DIR_ANTLR=${antlr}"
    "-DFETCHCONTENT_SOURCE_DIR_KGT=${kgt}"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=true"
  ];

  meta = src.meta // {
    description = "An interactive interpreter that transforms markdown-style expression into an ascii-art representation";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.petertrotman ];
    mainProgram = "diagon";
    platforms = lib.platforms.unix;
  };
}
