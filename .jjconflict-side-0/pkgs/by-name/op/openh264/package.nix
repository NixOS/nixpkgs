{ lib
, fetchFromGitHub
, fetchpatch2
, gtest
, meson
, nasm
, ninja
, pkg-config
, stdenv
, windows
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openh264";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "openh264";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ai7lcGcQQqpsLGSwHkSs7YAoEfGCIbxdClO6JpGA+MI=";
  };

  patches = [
    # build: fix build with meson on riscv64
    # https://github.com/cisco/openh264/pull/3773
    (fetchpatch2 {
      name = "openh264-riscv64.patch";
      url = "https://github.com/cisco/openh264/commit/cea886eda8fae7ba42c4819e6388ce8fc633ebf6.patch";
      hash = "sha256-ncXuGgogXA7JcCOjGk+kBprmOErFohrYjYzZYzAbbDQ=";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    nasm
    ninja
    pkg-config
  ];

  buildInputs = [
    gtest
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [
    windows.pthreads
  ];

  strictDeps = true;

  meta = {
    homepage = "https://www.openh264.org";
    description = "Codec library which supports H.264 encoding and decoding";
    changelog = "https://github.com/cisco/openh264/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    # See meson.build
    platforms = lib.platforms.windows ++ lib.intersectLists
      (lib.platforms.x86 ++ lib.platforms.arm ++ lib.platforms.aarch64 ++
       lib.platforms.loongarch64 ++ lib.platforms.riscv64)
      (lib.platforms.linux ++ lib.platforms.darwin);
  };
})
