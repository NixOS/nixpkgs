{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libpng,
  rlottie,
  giflib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lottieconverter";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "sot-tech";
    repo = "lottieconverter";
    rev = "r${finalAttrs.version}";
    hash = "sha256-oCFQsOQbWzmzClaTOeuEtGo7uXoKYtaJuSLLgqAQP1M=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libpng
    rlottie
    giflib
  ];

  cmakeFlags = [
    "-DSYSTEM_RL=1"
    "-DSYSTEM_GL=1"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 lottieconverter "$out/bin/lottieconverter"
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/sot-tech/LottieConverter/";
    description = "Lottie converter utility";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      CRTified
      nickcao
    ];
    mainProgram = "lottieconverter";
  };
})
