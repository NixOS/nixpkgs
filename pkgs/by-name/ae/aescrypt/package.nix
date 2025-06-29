{
  lib,
  stdenv,
  fetchurl,
  libiconv,
}:

stdenv.mkDerivation rec {
  version = "3.16";
  pname = "aescrypt";

  src = fetchurl {
    url = "https://www.aescrypt.com/download/v3/linux/aescrypt-${version}.tgz";
    sha256 = "sha256-4uGS0LReq5dI7+Wel7ZWzFXx+utZWi93q4TUSw7AhNI=";
  };

  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-liconv";

  preBuild = ''
    substituteInPlace src/Makefile --replace "CC=gcc" "CC?=gcc"
    cd src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp aescrypt $out/bin
    cp aescrypt_keygen $out/bin
  '';

  buildInputs = [ libiconv ];

  meta = {
    description = "Encrypt files with Advanced Encryption Standard (AES)";
    homepage = "https://www.aescrypt.com/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      lovek323
      qknight
    ];
    platforms = lib.platforms.all;
    hydraPlatforms = lib.platforms.unix;
  };
}
