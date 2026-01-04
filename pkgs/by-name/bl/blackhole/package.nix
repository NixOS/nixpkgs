{
  stdenv,
  lib,
  fetchFromGitHub,
  xcbuildHook,
  apple-sdk,
  nix-update-script,
  channel ? "256ch",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "blackhole";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "existentialaudio";
    repo = "BlackHole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jFKi5LJdTOMFa1mErH6WsjgCtLCKzwpgn2+T3Fp9MtQ=";
  };

  nativeBuildInputs = [
    xcbuildHook
  ];

  buildInputs = [ apple-sdk ];

  bundleId = "audio.existential.BlackHole${channel}";
  xcbuildFlags = [
    "-project"
    "BlackHole.xcodeproj"
    "-configuration"
    "Release"
    "PRODUCT_BUNDLE_IDENTIFIER=${finalAttrs.bundleId}"
    "GCC_PREPROCESSOR_DEFINITIONS=$GCC_PREPROCESSOR_DEFINITIONS kDriver_Name=\\\"blackhole${channel}\\\" kPlugIn_BundleID=\\\"${finalAttrs.bundleId}\\\" kPlugIn_Icon=\\\"BlackHole.icns\\\""
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Library/Audio/Plug-Ins/HAL
    mv Products/Release/BlackHole.driver $out/Library/Audio/Plug-Ins/HAL/Blackhole${channel}.driver

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Virtual audio driver for macOS";
    homepage = "https://existential.audio/blackhole";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
})
