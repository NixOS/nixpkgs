{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmocka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "croaring";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "RoaringBitmap";
    repo = "CRoaring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I9ioukybY8NXBFmQd9xFyrd9Ye2FuGTewuX1pCQscQM=";
  };

  # roaring.pc.in cannot handle absolute CMAKE_INSTALL_*DIRs, nor
  # overridden CMAKE_INSTALL_FULL_*DIRs. With Nix, they are guaranteed
  # to be absolute so the following patch suffices (see #144170).
  patches = [ ./fix-pkg-config.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cmocka ];

  doCheck = true;

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
