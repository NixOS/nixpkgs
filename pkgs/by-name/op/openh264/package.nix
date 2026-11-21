{
  lib,
  fetchFromGitHub,
  gtest,
  meson,
  nasm,
  ninja,
  pkg-config,
  stdenv,
  windows,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openh264";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "openh264";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Elcd//UfC928mFXBwYN3L/+XegZ5aXoa/he/2Qw7YaQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    nasm
    ninja
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isWindows [ windows.pthreads ];

  mesonFlags = [ (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck) ];

  doCheck = true;
  checkInputs = [ gtest ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    homepage = "https://www.openh264.org";
    description = "Codec library which supports H.264 encoding and decoding";
    changelog = "https://github.com/cisco/openh264/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    pkgConfigModules = [ "openh264" ];
    # See meson.build
    platforms =
      lib.platforms.windows
      ++ lib.intersectLists (
        lib.platforms.x86
        ++ lib.platforms.arm
        ++ lib.platforms.aarch64
        ++ lib.platforms.loongarch64
        ++ lib.platforms.riscv64
        ++ lib.platforms.power
      ) lib.platforms.unix;
  };
})
