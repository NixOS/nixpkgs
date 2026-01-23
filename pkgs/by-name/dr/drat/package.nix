{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drat";
  version = "0.1.3-unstable-2024-01-07";

  src = fetchFromGitHub {
    owner = "jivanpal";
    repo = "drat";
    rev = "af573b9e067e8b6cbcc4825946e7e636b30c748f";
    hash = "sha256-1NmqG73sP25Uqf7DiSPgt7drONOg9ZkrtCS0tYVjSU0=";
  };

  # Don't blow up on warnings; it makes upgrading the compiler difficult.
  postPatch = ''
    substituteInPlace Makefile --replace-fail "-Werror" ""
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install drat $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Utility for performing data recovery and analysis of APFS partitions/containers";
    homepage = "https://github.com/jivanpal/drat";
    changelog = "https://github.com/jivanpal/drat/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ philiptaron ];
    mainProgram = "drat";
    platforms = lib.platforms.all;
  };
})
