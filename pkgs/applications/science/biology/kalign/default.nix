{ lib
, stdenv
, cmake
, fetchFromGitHub
, llvmPackages
, enableSse4_1 ? stdenv.hostPlatform.sse4_1Support
, enableAvx ? stdenv.hostPlatform.avxSupport
, enableAvx2 ? stdenv.hostPlatform.avx2Support
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kalign";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "TimoLassmann";
    repo = "kalign";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-QufTiaiRcNOnLhOO4cnOE9bNcj9mlCg/ERFIHJB8KOU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  cmakeFlags =
    # these flags are ON by default
    lib.optional (!enableSse4_1) "-DENABLE_SSE=OFF"
    ++ lib.optional (!enableAvx) "-DENABLE_AVX=OFF"
    ++ lib.optional (!enableAvx2) "-DENABLE_AVX2=OFF";

  doCheck = true;

  meta = {
    description = "A fast multiple sequence alignment program";
    homepage = "https://github.com/TimoLassmann/kalign";
    changelog = "https://github.com/TimoLassmann/kalign/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.unix;
  };
})
