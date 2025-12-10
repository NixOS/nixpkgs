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
  # https://github.com/BRL-CAD/brlcad/blob/<TAG>/CMakeLists.txt#L234
  bext = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "bext";
    rev = "17f3f0c802dc7a60e5f25751019c0626cdbc7094";
    fetchSubmodules = true;
    hash = "sha256-0njc2gTdFKDeTVktdruQjpcdZeAjXimI6/FuL4f32M0=";
  };

  version = "7.42.0";
  tag = "rel-${lib.replaceStrings [ "." ] [ "-" ] version}";
in

stdenv.mkDerivation {
  pname = "brlcad";
  inherit version;

  src = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "brlcad";
    inherit tag;
    hash = "sha256-GDhP3880jLBxYFTZsBzwd5BB7e8mVGDBMghQ9BDeAvw=";
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
    changelog = "https://github.com/BRL-CAD/brlcad/releases/tag/${tag}";
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
}
