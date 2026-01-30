{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  curl,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osslsigncode";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "mtrojnar";
    repo = "osslsigncode";
    rev = finalAttrs.version;
    sha256 = "sha256-ua/4OouuMWTvfFbdOVVZpf1Z43JoPiptlFl+THaef58=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    curl
    openssl
  ];

  meta = {
    homepage = "https://github.com/mtrojnar/osslsigncode";
    description = "OpenSSL based Authenticode signing for PE/MSI/Java CAB files";
    mainProgram = "osslsigncode";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      mmahut
      prusnak
    ];
    platforms = lib.platforms.all;
  };
})
