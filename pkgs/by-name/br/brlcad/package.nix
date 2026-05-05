{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  gitMinimal,
  lemon,
  re2c,

  # buildInputs
  fontconfig,
  libX11,
  libXi,
  freetype,
  libgbm,
  tcl,
}:

let
  # https://github.com/BRL-CAD/brlcad/blob/rel-7-42-2/CMakeLists.txt#L234
  bext = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "bext";
    rev = "f9074f84c87605f89d912069cee1b1e710ead635";
    fetchSubmodules = true;
    hash = "sha256-jCBw4aDk/bmz2Woe9qIA88mgLRRZSu7zDYM5pi3MbP8=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "brlcad";
  version = "7.42.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "brlcad";
    tag = "rel-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    leaveDotGit = true;
    # hash = "sha256-smsCbUWlAfO9xyT8Bz/vLRkTJuehF9xANrP8bT//t18=";
    hash = "sha256-rLa1eHfBhNpVeYAjHUe1LjZ4a0VYc+Nh1RNAjZQpKug=";
  };

  # patches = [
  #   # This commit was bringing an impurity in the rpath resulting in:
  #   # RPATH of binary /nix/store/rq2hjvfgq2nvh5zxch51ij34rqqdpark-brlcad-7.38.0/bin/tclsh contains a forbidden reference to /build/
  #   (fetchpatch {
  #     url = "https://github.com/BRL-CAD/brlcad/commit/fbdbf042b2db4c7d46839a17bbf4985cdb81f0ae.patch";
  #     revert = true;
  #     hash = "sha256-Wfihd7TLkE8aOpLdDtYmhhd7nZijiVGh1nbUjWr/BjQ=";
  #   })
  # ];

  nativeBuildInputs = [
    cmake
    gitMinimal
    lemon
    re2c
  ];

  buildInputs = [
    fontconfig
    freetype
    libX11
    libXi
    libgbm
    tcl
  ];

  cmakeFlags = [
    (lib.cmakeBool "BRLCAD_ENABLE_STRICT" false)
    (lib.cmakeFeature "BRLCAD_EXT_SOURCE_DIR" "${bext}")
  ];

  # env.NIX_CFLAGS_COMPILE = toString [
  #   # Needed with GCC 12
  #   "-Wno-error=array-bounds"
  # ];

  meta = {
    homepage = "https://brlcad.org";
    description = "BRL-CAD is a powerful cross-platform open source combinatorial solid modeling system";
    changelog = "https://github.com/BRL-CAD/brlcad/releases/tag/${finalAttrs.tag}";
    license = with lib.licenses; [
      lgpl21
      bsd2
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    badPlatforms = [
      # error Exactly one of ON_LITTLE_ENDIAN or ON_BIG_ENDIAN should be defined.
      "aarch64-linux"
    ];
  };
})
