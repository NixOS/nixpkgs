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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "ParadigmMC";
    repo = "mcman";
    rev = version;
    hash = "sha256-AzD+Xepmft8d1G3VB0YHTpUfQeSYH3rMSry4yiUX3Uk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mcapi-0.2.0" = "sha256-wHXA+4DQVQpfSCfJLFuc9kUSwyqo6T4o0PypYdhpp5s=";
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
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Powerful Minecraft Server Manager CLI";
    homepage = "https://github.com/ParadigmMC/mcman";
    changelog = "https://github.com/ParadigmMC/mcman/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "mcman";
  };
}
