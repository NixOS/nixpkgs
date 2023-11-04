{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mcman";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ParadigmMC";
    repo = "mcman";
    rev = version;
    hash = "sha256-w8wIVpG3Uvx6Vdzyiu4gJjjx4smv+x18XWNEyPL/d6s=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "java-properties-1.4.1" = "sha256-Ij3gYrox0O813mzI+GcUa5VctR14wNKNaZ+4ynNkTmU=";
      "mcapi-0.2.0" = "sha256-P90cQhP8kRVZ6LWYYyBWR4Qg7xS8w6+tclFMDyzo9kk=";
      "pathdiff-0.2.1" = "sha256-+X1afTOLIVk1AOopQwnjdobKw6P8BXEXkdZOieHW5Os=";
      "rpackwiz-0.1.0" = "sha256-pOotNPIZS/BXiJWZVECXzP1lkb/o9J1tu6G2OqyEnI8=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Powerful Minecraft Server Manager CLI";
    homepage = "https://github.com/ParadigmMC/mcman";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "mcman";
  };
}
