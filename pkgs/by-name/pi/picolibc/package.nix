{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  nix-update-script,
  pkgsCross,

  # General Build Options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L40-L57
  multilib ? true,
  sanitize-bounds ? false,
  sanitize-trap-on-error ? false,
  profile ? false,
  analyzer ? false,
  assert-verbose ? true,
  fast-strcmp ? true,

  # Testing options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L75
  picolib ? stdenv.hostPlatform.isNone,
  semihost ? stdenv.hostPlatform.isNone,

  # Stdio Options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L114
  tinystdio ? true,
  io-c99-formats ? true,
  io-long-long ? false,
  io-pos-args ? false,
  io-long-double ? false,

  # Tinystdio options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L129
  io-float-exact ? true,
  atomic-ungetc ? true,
  posix-console ? !stdenv.hostPlatform.isNone,
  format-default ? "double",
  printf-aliases ? true,
  io-percent-b ? false,
  printf-small-ultoa ? true,
  printf-percent-n ? false,
  minimal-io-long-long ? false,
  fast-bufio ? false,
  io-wchar ? false,

  # Internaltionalization options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L181
  mb-capable ? false,
  mb-extended-charsets ? false,
  mb-ucs-charsets ? "auto",
  mb-iso-charsets ? "auto",
  mb-jis-charsets ? "auto",
  mb-windows-charsets ? "auto",

  # Startup/shutdown options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L198
  picocrt ? stdenv.hostPlatform.isNone,
  picocrt-enable-mmu ? true,
  picocrt-lib ? true,
  picoexit ? true,
  initfini-array ? true,
  crt-runtime-size ? false,

  # Legacy (non-picoexit) startup/shutdown options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L217
  newlib-atexit-dynamic-alloc ? false,
  newlib-global-atexit ? !stdenv.hostPlatform.isNone,
  newlib-register-fini ? false,

  # Malloc options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L228
  newlib-nano-malloc ? true,
  nano-malloc-clear-freed ? false,

  # Locking options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L237
  single-thread ? false,

  # TLS storage options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L244
  thread-local-storage ? "picolibc",
  tls-model ? if stdenv.hostPlatform.isNone then "local-exec" else "global-dynamic",
  newlib-global-errno ? false,
  errno-function ? if stdenv.hostPlatform.isNone then "false" else "auto",
  tls-rp2040 ? false,

  # Math options
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/meson_options.txt#L261
  want-math-errno ? false,
}:
let
  inherit (lib.strings) mesonBool mesonOption;

  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "picolibc";
  version = "1.8.9-2";
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "picolibc";
    repo = "picolibc";
    tag = finalAttrs.version;
    hash = "sha256-djOZKkinsaaYD4tUEA6mKdo+5em0GP1/+rI0mIm7Vs8=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  # Default values taken from
  # Build fails without using them.
  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/doc/os.md?plain=1#L183
  mesonFlags = [
    (mesonBool "multilib" multilib)
    (mesonBool "sanitize-bounds" sanitize-bounds)
    (mesonBool "sanitize-trap-on-error" sanitize-trap-on-error)
    (mesonBool "profile" profile)
    (mesonBool "analyzer" analyzer)
    (mesonBool "assert-verbose" assert-verbose)
    (mesonBool "fast-strcmp" fast-strcmp)

    # Testing options
    (mesonBool "picolib" picolib)
    (mesonBool "semihost" semihost)
    (mesonBool "use-stdlib" true)

    # Install options
    (mesonOption "specsdir" "${placeholder "dev"}/lib")

    (mesonBool "tinystdio" tinystdio)
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

    (mesonBool "mb-capable" mb-capable)
    (mesonBool "mb-extended-charsets" mb-extended-charsets)
    (mesonOption "mb-ucs-charsets" mb-ucs-charsets)
    (mesonOption "mb-iso-charsets" mb-iso-charsets)
    (mesonOption "mb-jis-charsets" mb-jis-charsets)
    (mesonOption "mb-windows-charsets" mb-windows-charsets)

    (mesonBool "picocrt" picocrt)
    (mesonBool "picocrt-enable-mmu" picocrt-enable-mmu)
    (mesonBool "picocrt-lib" picocrt-lib)
    (mesonBool "picoexit" picoexit)
    (mesonBool "newlib-initfini-array" initfini-array)
    (mesonBool "crt-runtime-size" crt-runtime-size)

    (mesonBool "newlib-atexit-dynamic-alloc" newlib-atexit-dynamic-alloc)
    (mesonBool "newlib-global-atexit" newlib-global-atexit)
    (mesonBool "newlib-register-fini" newlib-register-fini)

    (mesonBool "newlib-nano-malloc" newlib-nano-malloc)
    (mesonBool "nano-malloc-clear-freed" nano-malloc-clear-freed)

    (mesonBool "newlib-multithread" (!single-thread))

    (mesonOption "thread-local-storage" thread-local-storage)
    (mesonOption "tls-model" tls-model)
    (mesonBool "newlib-global-errno" newlib-global-errno)
    (mesonOption "errno-function" errno-function)
    (mesonBool "tls-rp2040" tls-rp2040)

    (mesonBool "want-math-errno" want-math-errno)
  ]
  ++ lib.optionals finalAttrs.doCheck [
    (mesonBool "tests" true)
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
      maintainers = [ maintainers.RossSmyth ];
      # https://github.com/picolibc/picolibc/tree/db4d0fe5952d5ecd714781e3212d4086d970735a?tab=readme-ov-file#supported-architectures
      platforms = lib.platforms.all;
    };
})
