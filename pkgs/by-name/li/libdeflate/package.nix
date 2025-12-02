{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
  pkgsStatic,
  cmake,
  zlib,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdeflate";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "ebiggers";
    repo = "libdeflate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2TiV3kmFs9j4aYetoYeWg3+MoZ542/0zaD0hwn9b8ZA=";
  };

  cmakeFlags = [
    "-DLIBDEFLATE_BUILD_TESTS=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [ "-DLIBDEFLATE_BUILD_SHARED_LIB=OFF" ];

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = [ zlib ];

  passthru.tests = {
    static = pkgsStatic.libdeflate;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  doCheck = true;

  meta = with lib; {
    description = "Fast DEFLATE/zlib/gzip compressor and decompressor";
    license = licenses.mit;
    homepage = "https://github.com/ebiggers/libdeflate";
    changelog = "https://github.com/ebiggers/libdeflate/blob/v${finalAttrs.version}/NEWS.md";
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [
      kaction
    ];
    pkgConfigModules = [ "libdeflate" ];
  };
})
