{
  lib,
  stdenv,
  fetchpatch,
  ninja,
  libusb1,
  meson,
  boost,
  fetchFromGitHub,
  pkg-config,
  microsoft-gsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ite-backlight";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "hexagonal-sun";
    repo = "ite-backlight";
    rev = "v${finalAttrs.version}";
    sha256 = "1hany4bn93mac9qyz97r1l858d48zdvvmn3mabzr3441ivqr9j0a";
  };

  nativeBuildInputs = [
    ninja
    pkg-config
    meson
    microsoft-gsl
  ];

  buildInputs = [
    boost
    libusb1
  ];

  patches = [
    (fetchpatch {
      name = "fix-gcc13-build-failure.patch";
      url = "https://github.com/hexagonal-sun/ite-backlight/commit/dc8c19d4785d80cbe7a82869daee1f723d3f3fb2.patch";
      hash = "sha256-iTRTVy7qB2z1ip135b8k3RufTBzeJaP1wdrRWN9tPsU=";
    })
  ];

  meta = {
    description = "Commands to control ite-backlight devices";
    longDescription = ''
      This project aims to provide a set of simple utilities for controlling ITE 8291
      keyboard backlight controllers.
    '';
    license = with lib.licenses; [ mit ];
    homepage = "https://github.com/hexagonal-sun/ite-backlight";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hexagonal-sun ];
  };
})
