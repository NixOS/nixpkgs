{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmocka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "croaring";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "RoaringBitmap";
    repo = "CRoaring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wks7kkF0va7RUJXY74ku/yWTSsHQKlFczfhAHyuNudM=";
  };

  # roaring.pc.in cannot handle absolute CMAKE_INSTALL_*DIRs, nor
  # overridden CMAKE_INSTALL_FULL_*DIRs. With Nix, they are guaranteed
  # to be absolute so the following patch suffices (see #144170).
  patches = [ ./fix-pkg-config.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cmocka ];

  doCheck = true;

  postPatch = ''
    # Fixes the build of dependent projects by updating the supported
    # CMake version.
    # Issue: https://github.com/RoaringBitmap/CRoaring/issues/793
    # PR: https://github.com/RoaringBitmap/CRoaring/pull/794
    substituteInPlace CMakeLists.txt \
      --replace-fail '2.8...3.15' '3.15'
  '';

  preConfigure = ''
    mkdir -p dependencies/.cache
    ln -s ${
      fetchFromGitHub {
        owner = "clibs";
        repo = "cmocka";
        rev = "f5e2cd77c88d9f792562888d2b70c5a396bfbf7a";
        hash = "sha256-Oq0nFsZhl8IF7kQN/LgUq8VBy+P7gO98ep/siy5A7Js=";
      }
    } dependencies/.cache/cmocka
  '';

  cmakeFlags = [ (lib.cmakeBool "ROARING_USE_CPM" false) ];

  meta = {
    description = "Compressed bitset library for C and C++";
    homepage = "https://roaringbitmap.org";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.all;
  };
})
