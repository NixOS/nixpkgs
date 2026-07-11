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
in
stdenvNoLibc.mkDerivation (finalAttrs: {
  pname = "picolibc";
  version = "1.8.11";
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "picolibc";
    repo = "picolibc";
    tag = finalAttrs.version;
    hash = "sha256-9xFkUZJJ2ikyi4/m5B+oDa5Zznm/1aPa8El2JLEZBE8=";
  };

  depsBuildBuild = lib.optionals canExecute [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonFlags = [
    # Always non-default from upstream
    (lib.mesonBool "use-stdlib" true)
    (lib.mesonOption "specsdir" "${placeholder "dev"}/lib")

    # Multi-lib (cross-compilation)
    (lib.mesonBool "multilib" multilib)
    (lib.mesonOption "multilib-list" (lib.concatStringsSep "," multilib-list))
    (lib.mesonOption "multilib-exclude" (lib.concatStringsSep "," multilib-exclude))

    # Platform-dependent: picolibc defaults are for bare-metal; adjust for
    # hosted (non-none) platforms.
    (lib.mesonBool "picolib" stdenvNoLibc.hostPlatform.isNone)
    (lib.mesonBool "semihost" stdenvNoLibc.hostPlatform.isNone)
    (lib.mesonBool "picocrt" stdenvNoLibc.hostPlatform.isNone)
    (lib.mesonBool "posix-console" (!stdenvNoLibc.hostPlatform.isNone))
    (lib.mesonOption "tls-model" (
      if stdenvNoLibc.hostPlatform.isNone then "local-exec" else "global-dynamic"
    ))
    (lib.mesonOption "errno-function" (
      if stdenvNoLibc.hostPlatform.isNone then "false" else "auto"
    ))
  ]
  ++ lib.optionals finalAttrs.doCheck [
    (lib.mesonBool "tests" true)
    (lib.mesonBool "native-tests" canExecute)
    (lib.mesonBool "native-math-tests" canExecute)
    # Something is broken with this and I'm not sure what.
    (lib.mesonOption "tests-cdefs" "false")
  ];

  doCheck = stdenvNoLibc.buildPlatform.canExecute stdenvNoLibc.hostPlatform;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      arm = pkgsCross.arm-embedded.picolibc;
    };
  };

  meta =
    let
      inherit (lib) licenses maintainers;
    in
    {
      description = "C library designed for embedded 32- and 64- bit systems";
      longDescription = ''
        Picolibc is library offering standard C library APIs that targets
        small embedded systems with limited RAM. Picolibc was formed by blending
        code from [Newlib](http://sourceware.org/newlib/) and
        [AVR Libc](https://www.nongnu.org/avr-libc/).
      '';
      homepage = "https://keithp.com/picolibc/";
      changelog = "https://github.com/picolibc/picolibc/releases/tag/${finalAttrs.version}";
      license = [
        licenses.bsd2
        licenses.bsd3
      ];
      maintainers = [ ];
      # https://github.com/picolibc/picolibc/tree/db4d0fe5952d5ecd714781e3212d4086d970735a?tab=readme-ov-file#supported-architectures
      platforms = lib.platforms.all;
    };
})
