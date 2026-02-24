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

stdenv.mkDerivation rec {
  pname = "osslsigncode";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "mtrojnar";
    repo = "osslsigncode";
    rev = version;
    sha256 = "sha256-UjjNXcHpPbyUz5CPsW+uVhZP0X9XGM3//IVv9VhmP7o=";
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
}
