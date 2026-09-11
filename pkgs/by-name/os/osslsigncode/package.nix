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
  version = "2.14";

  src = fetchFromGitHub {
    owner = "mtrojnar";
    repo = "osslsigncode";
    rev = finalAttrs.version;
    sha256 = "sha256-jAiGW6B3wxasESvpMRYxh0sWIPkV7L37owpwlNNlyxs=";
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
