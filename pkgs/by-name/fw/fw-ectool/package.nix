{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  pkg-config,
  libusb1,
  libftdi1,
}:

stdenv.mkDerivation {
  pname = "fw-ectool";
  version = "0-unstable-2024-04-23";

  src = fetchFromGitLab {
    domain = "gitlab.howett.net";
    owner = "DHowett";
    repo = "ectool";
    rev = "abdd574ebe3640047988cb928bb6789a15dd1390";
    hash = "sha256-j0Z2Uo1LBXlHZVHPm4Xjx3LZaI6Qq0nSdViyC/CjWC8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 3.1)' \
      'cmake_minimum_required(VERSION 4.0)'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
    libftdi1
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 src/ectool "$out/bin/ectool"
    runHook postInstall
  '';

  meta = with lib; {
    description = "EC-Tool adjusted for usage with framework embedded controller";
    homepage = "https://gitlab.howett.net/DHowett/ectool";
    license = licenses.bsd3;
    maintainers = [ maintainers.mkg20001 ];
    platforms = platforms.linux;
    mainProgram = "ectool";
  };
}
