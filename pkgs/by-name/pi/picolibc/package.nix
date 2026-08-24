{
  stdenvNoLibc,
  buildPackages,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  nix-update-script,
  pkgsCross,

  multilib ? true,
  multilib-list ? [ ],
  multilib-exclude ? [ ],
}:

let
  canExecute = stdenvNoLibc.buildPlatform.canExecute stdenvNoLibc.hostPlatform;
  isHosted = !stdenvNoLibc.hostPlatform.isNone;
in
stdenvNoLibc.mkDerivation (finalAttrs: {
  pname = "picolibc";
  version = "1.8.12-1";
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "picolibc";
    repo = "picolibc";
    tag = finalAttrs.version;
    hash = "sha256-FhTNgffsnHbzIXOOwCMe6O1FGkEtqWfw+e30RW+Y4K4=";
  };

  depsBuildBuild = lib.optionals canExecute [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonFlags = [
    # use-stdlib builds against a system C library, requiring a Linux-ABI libc
    # whose headers we can compile against (libc/native needs statx() & 64-bit
    # off_t/time_t)… so native glibc/musl only.
    (lib.mesonBool "use-stdlib" (
      isHosted
      && stdenvNoLibc.hostPlatform == stdenvNoLibc.buildPlatform
      && (stdenvNoLibc.hostPlatform.libc == "glibc" || stdenvNoLibc.hostPlatform.libc == "musl")
    ))
    (lib.mesonOption "specsdir" "${placeholder "dev"}/lib")

    # Multi-lib (cross-compilation)
    (lib.mesonBool "multilib" multilib)
    (lib.mesonOption "multilib-list" (lib.concatStringsSep "," multilib-list))
    (lib.mesonOption "multilib-exclude" (lib.concatStringsSep "," multilib-exclude))

    # Platform-dependent: picolibc defaults are for bare-metal; adjust for
    # hosted platforms.
    (lib.mesonBool "semihost" (!isHosted))
    (lib.mesonBool "picocrt" (!isHosted))
    (lib.mesonBool "posix-console" isHosted)
    (lib.mesonBool "initfini-array" (!isHosted))
    (lib.mesonOption "tls-model" (if isHosted then "global-dynamic" else "local-exec"))
    (lib.mesonOption "errno-function" (if isHosted then "auto" else "false"))

    # For hosted builds, disable os-fallback since sbrk.c in the fallback
    # library references __heap_start/__heap_end which are only defined for
    # bare-metal targets with an internal heap.
    (lib.mesonOption "os-fallback" (if isHosted then "false" else "auto"))
  ]
  ++ lib.optionals (stdenvNoLibc.hostPlatform.libc == "fblibc") [
    # Linkless cross toolchain: meson’s TLS auto-detect enables TLS then
    # rejects -ftls-model; fall back to non-thread-local errno.
    (lib.mesonBool "thread-local-storage" false)
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [
    (lib.mesonBool "tests" true)
    (lib.mesonBool "native-tests" canExecute)
    (lib.mesonBool "native-math-tests" canExecute)
    # Something is broken with this and I'm not sure what.
    (lib.mesonOption "tests-cdefs" "false")
  ];

  # The cross no-libc toolchains cannot link (no crt files), so meson’s
  # link-based probes (meaning the --defsym alias check that enables the printf
  # tests) all fail. Keep tests on the native build only.
  doCheck = canExecute && stdenvNoLibc.hostPlatform == stdenvNoLibc.buildPlatform;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      arm = pkgsCross.arm-embedded.picolibc;
      musl64 = pkgsCross.musl64.picolibc;
      riscv64 = pkgsCross.riscv64-embedded.picolibc;
    };
  };

  meta = {
    description = "C library designed for embedded 32- and 64-bit systems";
    longDescription = ''
      Picolibc is library offering standard C library APIs that targets small
      embedded systems with limited RAM. Picolibc was formed by blending code
      from [Newlib](http://sourceware.org/newlib/) and [AVR
      Libc](https://www.nongnu.org/avr-libc/).
    '';
    homepage = "https://keithp.com/picolibc/";
    changelog = "https://github.com/picolibc/picolibc/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      bsd2
      bsd3
    ];
    maintainers = with lib.maintainers; [ toastal ];
    badPlatforms = [ lib.systems.inspect.patterns.isMinGW ];
    # https://github.com/picolibc/picolibc/tree/${finalAttrs.version}?tab=readme-ov-file#supported-architectures
    platforms = lib.platforms.all;
  };
})
