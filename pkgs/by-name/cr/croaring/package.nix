{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmocka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "croaring";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "RoaringBitmap";
    repo = "CRoaring";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c4o8AMCtDGLChXxJKJyxkWhuYu7axqLb2ce8IOGk920=";
  };

  # roaring.pc.in cannot handle absolute CMAKE_INSTALL_*DIRs, nor
  # overridden CMAKE_INSTALL_FULL_*DIRs. With Nix, they are guaranteed
  # to be absolute so the following patch suffices (see #144170).
  patches = [ ./fix-pkg-config.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cmocka ];

  doCheck = true;

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
    maintainers = [ lib.maintainers.orivej ];
    platforms = lib.platforms.all;
  };
})
