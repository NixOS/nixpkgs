{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libnl,
  zstd,
  libusb1,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "morse-cli";
  version = "1.17.8";

  src = fetchFromGitHub {
    owner = "MorseMicro";
    repo = "morse_cli";
    tag = finalAttrs.version;
    hash = "sha256-K0J6iqUsEo1zuXnlPLxGUDipsMSRu2w4vW5lna/HJyU=";
  };

  buildInputs = [
    openssl
    libnl
    libusb1
    zstd
  ];

  nativeBuildInputs = [ pkg-config ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${libnl.dev}/include/libnl3"
    "-I${libusb1.dev}/include/libusb-1.0"
    "-Wno-error"
  ];

  makeFlags = [ "CONFIG_MORSE_TRANS_NL80211=1" ];

  installPhase = ''
    runHook preInstall

    install -D -m755 morse_cli "$out/bin/morse_cli"

    runHook postInstall
  '';

  meta = {
    description = "MorseMicro cli";
    homepage = "https://github.com/MorseMicro";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ govindsi ];
    platforms = lib.platforms.linux;
  };
})
