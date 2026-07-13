{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhangul";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "libhangul";
    repo = "libhangul";
    hash = "sha256-1cTDsRJpT5TLdJN8D2LfOISWeAOlSO6zKZOaCrTxooM=";
    tag = "libhangul-${finalAttrs.version}";
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
