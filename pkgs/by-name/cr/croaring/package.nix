{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmocka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "croaring";
  version = "5.2.4";

  src = fetchFromGitHub {
    owner = "RoaringBitmap";
    repo = "CRoaring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ykAF7rX4UnTIPtvZXO3ssTUX7IFOSrBPn1KXp/qNA/o=";
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
    maintainers = with lib.maintainers; [
      hythera
      shymega
    ];
    platforms = lib.platforms.all;
  };
})
