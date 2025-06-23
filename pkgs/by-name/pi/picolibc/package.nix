{
  lib,
  stdenvNoLibc,
  buildPackages,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
  pkgsCross,
}:
let
  inherit (lib.strings) mesonBool mesonOption;

  canExecute = stdenvNoLibc.buildPlatform.canExecute stdenvNoLibc.hostPlatform;
in
stdenvNoLibc.mkDerivation (finalAttrs: {
  pname = "picolibc";
  version = "1.8.10-2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "picolibc";
    repo = "picolibc";
    tag = finalAttrs.version;
    hash = "sha256-riQWdqi5LIng7+ZZNMWr1Dvxg/hWVRC1x8UEfK8IRC4=";
  };

  postPatch = ''
    patchShebangs scripts
  '';

  strictDeps = true;
  depsBuildBuild = [
    # Prepare for hooking up to stdenv libc
    # Requires meson is in depsBuildBuild
    buildPackages.stdenv.cc
    meson
  ];

  nativeBuildInputs = [
    ninja
  ];

  hardeningDisable = [ "pie" ];

  mesonFlags = [
    # https://github.com/picolibc/picolibc/blob/1.8.10-2/scripts/do-configure#L74
    (mesonBool "tinystdio" false)
    (mesonOption "specsdir" "${placeholder "dev"}/lib")
  ]
  ++ lib.optionals (!stdenvNoLibc.hostPlatform.isNone) [
    # https://github.com/picolibc/picolibc/blob/0c6e6c69b6d78363d8e42a3861243b99bc6abb4b/scripts/do-native-configure#L37
    (mesonOption "tls-model" "global-dynamic")
    (mesonBool "thread-local-storage" true)
    (mesonOption "errno-function" "auto")
    (mesonBool "multilib" false)
    (mesonBool "picolib" false)
    (mesonBool "picocrt" false)
    (mesonBool "semihost" false)
    (mesonBool "posix-console" true)
    (mesonBool "native-tests" true)
    (mesonBool "newlib-global-atexit" true)
    (mesonBool "initfini-array" false)
    (mesonBool "use-stdlib" true)
    (mesonBool "sanitize-bounds" true)
  ]
  # https://github.com/picolibc/picolibc/blob/1.8.10-2/scripts/do-x86_64-configure
  # https://github.com/picolibc/picolibc/blob/1.8.10-2/scripts/do-x86-configure
  ++ lib.optional stdenvNoLibc.hostPlatform.isx86 (mesonBool "tests-enable-posix-io" false)
  # https://github.com/picolibc/picolibc/blob/1.8.10-2/scripts/do-x86_64-configure
  ++ lib.optional stdenvNoLibc.hostPlatform.isx86_64 (mesonBool "multilib" false)
  ++ lib.optional finalAttrs.doCheck (mesonBool "tests" true);

  doCheck = canExecute;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      arm = pkgsCross.arm-embedded.picolibc;
    };
  };

  meta = {
    description = "C library designed for embedded 32- and 64- bit systems";
    longDescription = ''
      Picolibc is library offering standard C library APIs that targets
      small embedded systems with limited RAM. Picolibc was formed by blending
      code from [Newlib](http://sourceware.org/newlib/) and
      [AVR Libc](https://www.nongnu.org/avr-libc/).
    '';
    homepage = "https://keithp.com/picolibc/";
    changelog = "https://github.com/picolibc/picolibc/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      bsd2
      bsd3
    ];
    maintainers = with lib.maintainers; [ RossSmyth ];
    # https://github.com/picolibc/picolibc/tree/51a8b32857e75345c37652a80b5cda98b28d69e5?tab=readme-ov-file#supported-architectures
    platforms = lib.platforms.all;
  };
})
