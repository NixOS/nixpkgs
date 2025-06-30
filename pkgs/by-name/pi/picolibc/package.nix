{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  nix-update-script,
  pkgsCross,

  # Meson Option https://github.com/picolibc/picolibc/blob/51a8b32857e75345c37652a80b5cda98b28d69e5/meson_options.txt
  # Defaults: https://github.com/picolibc/picolibc/blob/1.8.10-2/scripts/do-native-configure
  #
  # General Build Options
  multilib ? true,
  sanitize-bounds ? false,
  sanitize-undefined ? false,
  sanitize-trap-on-error ? false,
  sanitize-allow-missing ? false,
  profile ? false,
  analyzer ? false,
  assert-verbose ? true,
  fast-strcmp ? true,

  # Testing options
  split-large-tests ? false,
  freestanding ? false,
  native-tests ? !stdenv.hostPlatform.isNone,
  native-math-tests ? native-tests,
  use-stdlib ? !stdenv.hostPlatform.isNone,
  picolib ? stdenv.hostPlatform.isNone,
  semihost ? stdenv.hostPlatform.isNone,
  fake-semihost ? false,

  # Stdio Options
  tinystdio ? true,
  io-c99-formats ? true,
  io-long-long ? false,
  io-pos-args ? false,
  io-long-double ? false,

  # Tinystdio options
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
  stdio-locking ? false,

  # Internaltionalization options
  mb-capable ? false,
  mb-extended-charsets ? false,
  mb-ucs-charsets ? "auto",
  mb-iso-charsets ? "auto",
  mb-jis-charsets ? "auto",
  mb-windows-charsets ? "auto",

  # Startup/shutdown options
  picocrt ? stdenv.hostPlatform.isNone,
  picocrt-enable-mmu ? true,
  picocrt-lib ? true,
  picoexit ? true,
  initfini-array ? false,
  initfini ? false,
  crt-runtime-size ? false,

  # Legacy startup/shutdown options
  newlib-global-atexit ? true,

  # Malloc options
  newlib-nano-malloc ? stdenv.hostPlatform.isNone,
  nano-malloc-clear-freed ? false,

  # Locking options
  single-thread ? false,

  # TLS storage options
  thread-local-storage ? true,
  tls-model ? if stdenv.hostPlatform.isNone then "local-exec" else "global-dynamic",
  newlib-global-errno ? false,
  errno-function ? if stdenv.hostPlatform.isNone then "false" else "auto",
  tls-rp2040 ? false,
  stack-protector-guard ? "auto",

  # Math options
  want-math-errno ? false,
}:

assert lib.elem format-default [
  "double"
  "float"
  "long-long"
  "integer"
  "minimal"
];
assert lib.elem thread-local-storage [
  true
  false
  "auto"
  "picolibc"
];
assert lib.elem tls-model [
  "global-dynamic"
  "local-dynamic"
  "initial-exec"
  "local-exec"
];
assert lib.elem stack-protector-guard [
  "global"
  "tls"
  "auto"
];

let
  inherit (lib.strings) mesonBool mesonOption;

  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # So users can use true and false literals.
  comboToStr =
    val:
    if val == true then
      "true"
    else if val == false then
      "false"
    else
      val;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "picolibc";
  version = "1.8.10-2";
  strictDeps = true;

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

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonFlags =
    [
      (mesonBool "multilib" multilib)
      (mesonBool "sanitize-bounds" sanitize-bounds)
      (mesonBool "sanitize-trap-on-error" sanitize-trap-on-error)
      (mesonBool "sanitize-undefined" sanitize-undefined)
      (mesonBool "sanitize-allow-missing" sanitize-allow-missing)
      (mesonBool "profile" profile)
      (mesonBool "analyzer" analyzer)
      (mesonBool "assert-verbose" assert-verbose)
      (mesonBool "fast-strcmp" fast-strcmp)

      # Testing options
      (mesonBool "split-large-tests" split-large-tests)
      (mesonBool "use-stdlib" true)
      (mesonBool "freestanding" freestanding)
      (mesonBool "native-tests" native-tests)
      (mesonBool "native-math-tests" native-math-tests)
      (mesonBool "picolib" picolib)
      (mesonBool "semihost" semihost)
      (mesonBool "fake-semihost" fake-semihost)

      # Install options
      (mesonOption "specsdir" "${placeholder "dev"}/lib")

      # Stdio options
      (mesonBool "tinystdio" tinystdio)
      (mesonBool "io-c99-formats" io-c99-formats)
      (mesonBool "io-long-long" io-long-long)
      (mesonBool "io-pos-args" io-pos-args)
      (mesonBool "io-long-double" io-long-double)

      # Tinystdio options
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

      # Internationalization options
      (mesonBool "mb-capable" mb-capable)
      (mesonBool "mb-extended-charsets" mb-extended-charsets)
      (mesonOption "mb-ucs-charsets" (comboToStr mb-ucs-charsets))
      (mesonOption "mb-iso-charsets" (comboToStr mb-iso-charsets))
      (mesonOption "mb-jis-charsets" (comboToStr mb-jis-charsets))
      (mesonOption "mb-windows-charsets" (comboToStr mb-windows-charsets))

      # Startup/shutdown options
      (mesonBool "picocrt" picocrt)
      (mesonBool "picocrt-enable-mmu" picocrt-enable-mmu)
      (mesonBool "picocrt-lib" picocrt-lib)
      (mesonBool "picoexit" picoexit)
      (mesonBool "initfini-array" initfini-array)
      (mesonBool "initfini" initfini)
      (mesonBool "crt-runtime-size" crt-runtime-size)

      # Legcy shutdown options
      (mesonBool "newlib-global-atexit" newlib-global-atexit)

      # Malloc options
      (mesonBool "newlib-nano-malloc" newlib-nano-malloc)
      (mesonBool "nano-malloc-clear-freed" nano-malloc-clear-freed)

      # Locking options
      (mesonBool "single-thread" (!single-thread))

      # TLS options
      (mesonOption "thread-local-storage" (comboToStr thread-local-storage))
      (mesonOption "tls-model" tls-model)
      (mesonBool "newlib-global-errno" newlib-global-errno)
      (mesonOption "errno-function" errno-function)
      (mesonBool "tls-rp2040" tls-rp2040)
      (mesonOption "stack-protector-guard" stack-protector-guard)

      (mesonBool "want-math-errno" want-math-errno)
    ]
    ++ lib.optionals finalAttrs.doCheck [
      (mesonBool "tests" true)
      # Something is broken with this and I'm not sure what.
      (mesonOption "tests-cdefs" (comboToStr false))
    ];

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
