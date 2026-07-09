{
  stdenvNoLibc,
  buildPackages,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  nix-update-script,
  pkgsCross,

  # General Build Options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L40
  multilib ? true,
  multilib-list ? [ ],
  multilib-exclude ? [ ],
  sanitize-bounds ? false,
  sanitize-undefined ? false,
  sanitize-trap-on-error ? false,
  sanitize-allow-missing ? false,
  profile ? false,
  analyzer ? false,
  assert-verbose ? true,
  fast-strcmp ? true,
  sanitize ? "none",

  # Testing options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L87
  picolib ? stdenvNoLibc.hostPlatform.isNone,
  semihost ? stdenvNoLibc.hostPlatform.isNone,
  fake-semihost ? true,

  # Stdio Options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L125
  io-c99-formats ? true,
  io-long-long ? false,
  io-pos-args ? false,
  io-long-double ? false,

  # Tinystdio options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L129
  io-float-exact ? true,
  atomic-ungetc ? true,
  posix-console ? !stdenvNoLibc.hostPlatform.isNone,
  format-default ? "double",
  printf-aliases ? true,
  io-percent-b ? false,
  printf-small-ultoa ? true,
  printf-percent-n ? false,
  minimal-io-long-long ? false,
  fast-bufio ? false,
  io-wchar ? false,
  stdio-locking ? false,
  have-fcntl ? false,
  fstat-bufsiz ? false,

  # Internationalization options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L166
  mb-capable ? false,
  mb-extended-charsets ? false,
  mb-ucs-charsets ? "auto",
  mb-iso-charsets ? "auto",
  mb-jis-charsets ? "auto",
  mb-windows-charsets ? "auto",

  # Startup/shutdown options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L180
  picocrt ? stdenvNoLibc.hostPlatform.isNone,
  picocrt-enable-mmu ? true,
  picocrt-lib ? true,
  initfini-array ? true,
  initfini ? false,
  crt-runtime-size ? false,

  # Legacy (non-picoexit) startup/shutdown options

  # Malloc options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L194
  enable-malloc ? true,
  malloc-clear-freed ? false,
  internal-heap ? 0,

  # Locking options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L206
  single-thread ? false,

  # TLS storage options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L209
  thread-local-storage ? "picolibc",
  thread-local-storage-api ? true,
  tls-model ? if stdenvNoLibc.hostPlatform.isNone then "local-exec" else "global-dynamic",
  newlib-global-errno ? false,
  errno-function ? if stdenvNoLibc.hostPlatform.isNone then "false" else "auto",
  tls-rp2040 ? false,
  stack-protector-guard ? "auto",

  # Math options
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/meson_options.txt#L225
  newlib-obsolete-math ? "auto",
  newlib-obsolete-math-float ? "auto",
  newlib-obsolete-math-double ? "auto",
  want-math-errno ? false,
}:
let
  inherit (lib.strings) mesonBool mesonOption;

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

  depsBuildBuild = lib.optionals (stdenvNoLibc.buildPlatform.canExecute stdenvNoLibc.hostPlatform) [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  # Default values taken from
  # Build fails without using them.
  # https://github.com/picolibc/picolibc/blob/95869670fb165e7c43e85c3d384a1e5682505244/doc/os.md?plain=1#L183
  mesonFlags = [
    (mesonBool "multilib" multilib)
    (mesonOption "multilib-list" (lib.concatStringsSep "," multilib-list))
    (mesonOption "multilib-exclude" (lib.concatStringsSep "," multilib-exclude))
    (mesonBool "sanitize-bounds" sanitize-bounds)
    (mesonBool "sanitize-undefined" sanitize-undefined)
    (mesonBool "sanitize-trap-on-error" sanitize-trap-on-error)
    (mesonBool "sanitize-allow-missing" sanitize-allow-missing)
    (mesonBool "profile" profile)
    (mesonBool "analyzer" analyzer)
    (mesonBool "assert-verbose" assert-verbose)
    (mesonBool "fast-strcmp" fast-strcmp)
    (mesonOption "sanitize" sanitize)

    # Testing options
    (mesonBool "picolib" picolib)
    (mesonBool "semihost" semihost)
    (mesonBool "fake-semihost" fake-semihost)
    (mesonBool "use-stdlib" true)

    # Install options
    (mesonOption "specsdir" "${placeholder "dev"}/lib")

    (mesonBool "io-c99-formats" io-c99-formats)
    (mesonBool "io-long-long" io-long-long)
    (mesonBool "io-pos-args" io-pos-args)
    (mesonBool "io-long-double" io-long-double)

    (mesonBool "io-float-exact" io-float-exact)
    (mesonBool "atomic-ungetc" atomic-ungetc)
    (mesonBool "posix-console" posix-console)
    (mesonOption "format-default" format-default)
    (mesonBool "printf-aliases" printf-aliases)
    (mesonBool "io-percent-b" io-percent-b)
    (mesonBool "printf-small-ultoa" printf-small-ultoa)
    (mesonBool "printf-percent-n" printf-percent-n)
    (mesonBool "minimal-io-long-long" minimal-io-long-long)
    (mesonBool "fast-bufio" fast-bufio)
    (mesonBool "io-wchar" io-wchar)
    (mesonBool "stdio-locking" stdio-locking)
    (mesonBool "have-fcntl" have-fcntl)
    (mesonBool "fstat-bufsiz" fstat-bufsiz)

    (mesonBool "mb-capable" mb-capable)
    (mesonBool "mb-extended-charsets" mb-extended-charsets)
    (mesonOption "mb-ucs-charsets" mb-ucs-charsets)
    (mesonOption "mb-iso-charsets" mb-iso-charsets)
    (mesonOption "mb-jis-charsets" mb-jis-charsets)
    (mesonOption "mb-windows-charsets" mb-windows-charsets)

    (mesonBool "picocrt" picocrt)
    (mesonBool "picocrt-enable-mmu" picocrt-enable-mmu)
    (mesonBool "picocrt-lib" picocrt-lib)
    (mesonBool "initfini-array" initfini-array)
    (mesonBool "initfini" initfini)
    (mesonBool "crt-runtime-size" crt-runtime-size)

    (mesonBool "enable-malloc" enable-malloc)
    (mesonBool "malloc-clear-freed" malloc-clear-freed)
    (mesonOption "internal-heap" (toString internal-heap))

    (mesonBool "single-thread" single-thread)

    (mesonOption "thread-local-storage" thread-local-storage)
    (mesonBool "thread-local-storage-api" thread-local-storage-api)
    (mesonOption "tls-model" tls-model)
    (mesonBool "newlib-global-errno" newlib-global-errno)
    (mesonOption "errno-function" errno-function)
    (mesonBool "tls-rp2040" tls-rp2040)
    (mesonOption "stack-protector-guard" stack-protector-guard)

    (mesonOption "newlib-obsolete-math" newlib-obsolete-math)
    (mesonOption "newlib-obsolete-math-float" newlib-obsolete-math-float)
    (mesonOption "newlib-obsolete-math-double" newlib-obsolete-math-double)
    (mesonBool "want-math-errno" want-math-errno)
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [
    (mesonBool "tests" true)
    (mesonBool "native-tests" canExecute)
    (mesonBool "native-math-tests" canExecute)
    # Something is broken with this and I'm not sure what.
    (mesonOption "tests-cdefs" "false")
  ];

  doCheck = canExecute;

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
