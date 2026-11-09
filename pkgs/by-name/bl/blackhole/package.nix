{
  stdenv,
  lib,
  fetchFromGitHub,
  xcbuildHook,
  apple-sdk,
  nix-update-script,
  channel ? "256ch",
}:
let
  numChannels = lib.toIntBase10 (lib.removeSuffix "ch" channel);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "blackhole";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "existentialaudio";
    repo = "BlackHole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kuIaoXA0K7SFPXKFHqcilTbf1zn9Ol3JYVpnkFuQEZg=";
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
    "GCC_PREPROCESSOR_DEFINITIONS=$GCC_PREPROCESSOR_DEFINITIONS kNumber_Of_Channels=${toString numChannels} kDriver_Name=\\\"BlackHole\\\" kPlugIn_BundleID=\\\"${finalAttrs.bundleId}\\\" kPlugIn_Icon=\\\"BlackHole.icns\\\""
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Library/Audio/Plug-Ins/HAL
    mv Products/Release/BlackHole.driver $out/Library/Audio/Plug-Ins/HAL/BlackHole${channel}.driver

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
