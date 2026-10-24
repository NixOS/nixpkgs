{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhangul";
  version = "0.2.0-unstable-2026-10-11";

  src = fetchFromGitHub {
    owner = "libhangul";
    repo = "libhangul";
    rev = "23d2cd9d10d516d523d60c562dbcc7ea08139a09";
    hash = "sha256-OOf2+A7pS74tz9qH4aLwMWjNjvGE2LHA++EQT/G8w0k=";
  };

  preAutoreconf = "./autogen.sh";
  configureFlags = [
    # detection doesn't work for cross builds
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Core algorithm library for Korean input routines";
    mainProgram = "hangul";
    homepage = "https://github.com/libhangul/libhangul";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      ianwookim
      honnip
    ];
    platforms = lib.platforms.linux;
  };
})
