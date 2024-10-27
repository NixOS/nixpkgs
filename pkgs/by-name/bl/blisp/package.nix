{
  fetchFromGitHub,
  lib,
  stdenv,
  pkg-config,
  cmake,
  argtable,
  libserialport,
  darwin,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "blisp";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "pine64";
    repo = "blisp";
    rev = "refs/tags/v${version}";
    hash = "sha256-cN35VLbdQFA3KTZ8PxgpbsLGXqfFhw5eh3nEBRZqAm4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    argtable
    libserialport
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  cmakeFlags = [
    "-DBLISP_USE_SYSTEM_LIBRARIES=ON"
    "-DBLISP_BUILD_CLI=ON"
  ];

  patches = [ ./util.c.patch ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
    description = "ISP tool & library for Bouffalo Labs RISC-V Microcontrollers and SoCs";
    homepage = "https://github.com/pine64/blisp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ carlossless ];
    mainProgram = "blisp";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
