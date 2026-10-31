{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libucontext";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "kaniini";
    repo = "libucontext";
    rev = "libucontext-${finalAttrs.version}";
    hash = "sha256-asT0pV3s4L4zB2qtDJ+2XYxEP6agIEo1LtCuFeOjpRA=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  # Makefile builds the asm files with -Wa,--noexecstack, meson.build does not.
  # If you do not pass it, you get PT_GNU_STACK=RWE on static consumers of the library.
  # https://github.com/kaniini/libucontext/issues/83
  env.NIX_CFLAGS_COMPILE = "-Wa,--noexecstack";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/kaniini/libucontext";
    description = "ucontext implementation featuring glibc-compatible ABI";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lix ];
  };
})
