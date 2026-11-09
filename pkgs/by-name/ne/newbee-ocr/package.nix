{
  applyPatches,
  cmake,
  dejavu_fonts,
  fetchFromGitHub,
  imagemagick,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

let
  mnn = applyPatches {
    name = "MNN-3.4.1-source";
    src = fetchFromGitHub {
      owner = "alibaba";
      repo = "MNN";
      tag = "3.4.1";
      hash = "sha256-Q0mz/98TT+lpIYpTz3Wt99OdV4yOFzhkD+N025agP20=";
    };
    patches = [
      # MNN adds -D__STRICT_ANSI__ on Linux; under GCC 16 it triggers a
      # redefinition of std::abs(__int128) in libstdc++ (gnu++11 mode).
      # Still present in MNN 3.6.1, so carry the patch.
      ./mnn-drop-strict-ansi.patch
    ];
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "newbee-ocr";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "zibo-chen";
    repo = "newbee-ocr-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cm3T1RUv8Fo+8HQPZHKeX5/oZBUuzXwbwYj/6U93iL4=";
  };

  cargoHash = "sha256-ThPbJJ3ORyvYHiBwYvwjc7MLkLC0jd/GE7P//ycoVeQ=";

  __structuredAttrs = true;

  buildFeatures = [ "ocr-rs/build-mnn-from-source" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ openssl ];

  env.MNN_SOURCE_DIR = mnn;

  nativeInstallCheckInputs = [
    imagemagick
    versionCheckHook
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    magick -size 700x160 xc:white \
      -font ${dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf \
      -pointsize 96 -fill black -gravity center -annotate +0+0 '0123456789' \
      ocr-smoke-test.png
    $out/bin/nbocr r ocr-smoke-test.png | grep -q 0123456789

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line OCR tool based on ocr-rs";
    homepage = "https://github.com/zibo-chen/newbee-ocr-cli";
    changelog = "https://github.com/zibo-chen/newbee-ocr-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lanovets
      linsui
    ];
    mainProgram = "nbocr";
  };
})
