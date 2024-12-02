{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, fontconfig
, libX11
, libXi
, freetype
, mesa
}:

stdenv.mkDerivation rec {
  pname = "brlcad";
  version = "7.38.2";

  src = fetchFromGitHub {
    owner = "BRL-CAD";
    repo = "brlcad";
    rev = "refs/tags/rel-${lib.replaceStrings [ "." ] [ "-" ] version}";
    hash = "sha256-23UTeH4gY2x/QGYZ64glAkf6LmsXBAppIOHgoUdxgpo=";
  };

  patches = [
    # This commit was bringing an impurity in the rpath resulting in:
    # RPATH of binary /nix/store/rq2hjvfgq2nvh5zxch51ij34rqqdpark-brlcad-7.38.0/bin/tclsh contains a forbidden reference to /build/
    (fetchpatch {
      url = "https://github.com/BRL-CAD/brlcad/commit/fbdbf042b2db4c7d46839a17bbf4985cdb81f0ae.patch";
      revert = true;
      hash = "sha256-Wfihd7TLkE8aOpLdDtYmhhd7nZijiVGh1nbUjWr/BjQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    fontconfig
    libX11
    libXi
    freetype
    mesa
  ];

  cmakeFlags = [
    "-DBRLCAD_ENABLE_STRICT=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-bounds"
  ];

  meta = with lib; {
    homepage = "https://brlcad.org";
    description = "BRL-CAD is a powerful cross-platform open source combinatorial solid modeling system";
    changelog = "https://github.com/BRL-CAD/brlcad/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = with licenses; [ lgpl21 bsd2 ];
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.linux;
    # error Exactly one of ON_LITTLE_ENDIAN or ON_BIG_ENDIAN should be defined.
    broken = stdenv.system == "aarch64-linux";
  };
}
