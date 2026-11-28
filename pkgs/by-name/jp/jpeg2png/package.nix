{
  stdenv,
  lib,
  fetchFromGitHub,
  libjpeg,
  libpng,
  nix-update-script,
  llvmPackages,
  versionCheckHook,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jpeg2png";
  version = "1.02";

  src = fetchFromGitHub {
    owner = "ThioJoe";
    repo = "jpeg2png";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GTc2r9w87PUKQqhPPOD26smpqt6fIH4QyM14hmfYB1Q=";
  };

  postPatch = ''
    ${lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
      substituteInPlace Makefile \
        --replace-fail "CFLAGS+=-msse2 -mfpmath=sse" ""
    ''}
    ${lib.optionalString (!stdenv.hostPlatform.isWindows) ''
      substituteInPlace Makefile \
        --replace-fail "LIBS += -ljpeg -lpng -lm -lz -lpsapi" "LIBS += -ljpeg -lpng -lm -lz"
    ''}
  '';

  buildInputs = [
    libjpeg
    libpng
    zlib
  ] ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  makeFlags =
    lib.optionals (!stdenv.hostPlatform.isx86_64) [
      "SIMD=0"
    ]
    ++ lib.optionals stdenv.hostPlatform.isWindows [
      "WINDOWS=1"
    ];

  installPhase = ''
    runHook preInstall
    install -Dm0755 --target-directory=$out/bin jpeg2png
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Silky smooth JPEG decoding";
    homepage = "https://github.com/ThioJoe/jpeg2png";
    changelog = "https://github.com/ThioJoe/jpeg2png/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "jpeg2png";
  };
})
