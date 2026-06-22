{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmocka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "croaring";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "RoaringBitmap";
    repo = "CRoaring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FZP+RTV4pcj9pzDq3G2+sWeJnkh9WnW3Atd0CC9zDCk=";
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
