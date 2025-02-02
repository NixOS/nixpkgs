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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openh264";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "openh264";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K8p94P4XO6bUWCJuT6jR5Kmz3lamNDyclGWgsV6Lf9I=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace meson.build --replace-fail "'-Werror'," ""
  '';

  nativeBuildInputs = [
    meson
    nasm
    ninja
    pkg-config
  ];

  buildInputs =
    [
      gtest
    ]
    ++ lib.optionals stdenv.hostPlatform.isWindows [
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
    platforms =
      lib.platforms.windows
      ++ lib.intersectLists (
        lib.platforms.x86
        ++ lib.platforms.arm
        ++ lib.platforms.aarch64
        ++ lib.platforms.loongarch64
        ++ lib.platforms.riscv64
      ) (lib.platforms.linux ++ lib.platforms.darwin);
  };
})
