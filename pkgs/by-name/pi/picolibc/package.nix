{
  stdenv,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  nix-update-script,

  # General Build Options
  multilib ? true,
}:
let
  inherit (lib.strings) mesonBool mesonOption;
in
stdenv.mkDerivation (finalAttrs: {
  name = "picolibc";
  version = "1.8.9";
  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "picolibc";
    repo = "picolibc";
    rev = "db4d0fe5952d5ecd714781e3212d4086d970735a";
    hash = "sha256-W1zK9mLMfi5pbOpbSLxiB2qKdiyNjOSQu96NM94/fcY=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  # https://github.com/picolibc/picolibc/blob/e57b766cb5d80f23c20d05ab067001d85910f927/doc/os.md?plain=1#L183
  mesonFlags = [
    (mesonBool "multilib" multilib)
    (mesonOption "specsdir" "${placeholder "dev"}/lib")
    (mesonOption "tls-model" "global-dynamic")
    (mesonOption "errno-function" "auto")
    (mesonBool "picolib" false)
    (mesonBool "picocrt" false)
    (mesonBool "semihost" false)
    (mesonBool "use-stdlib" true)
    (mesonBool "posix-console" true)
    (mesonBool "newlib-global-atexit" true)
  ];

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
