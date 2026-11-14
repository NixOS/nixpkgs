{
  lib,
  stdenv,
  rustPlatform,
  fetchurl,
  fetchFromGitHub,
  fetchPnpmDeps,
  nix-update-script,
  # Native build inputs
  cargo-tauri,
  cmake,
  nodejs,
  pnpm,
  pnpmConfigHook,
  pkg-config,
  wrapGAppsHook4,
  # Build inputs
  atk,
  glib,
  glib-networking,
  gst_all_1,
  libheif,
  libde265,
  onnxruntime,
  openssl,
  webkitgtk_4_1,
  ffmpeg,
}:

let
  # See: https://github.com/julyx10/lap/blob/main/scripts/download_models.sh
  models = {
    "tokenizer.json" = (
      fetchurl {
        url = "https://huggingface.co/openai/clip-vit-base-patch32/resolve/main/tokenizer.json";
        hash = "sha256-tVasjJl1f/tncgivNLyMZyFXIRQRGm4Kr1+mn/C42EI=";
      }
    );
    "text_model.onnx" = (
      fetchurl {
        url = "https://huggingface.co/Xenova/clip-vit-base-patch32/resolve/main/onnx/text_model_quantized.onnx";
        hash = "sha256-c7qrhV1AYZDan6pJjP7fZfFc8wn0zHOFt7Ay5tCOXDo=";
      }
    );
    "vision_model.onnx" = (
      fetchurl {
        url = "https://huggingface.co/Xenova/clip-vit-base-patch32/resolve/main/onnx/vision_model_quantized.onnx";
        hash = "sha256-WD/REQpRRmeBL+59aElSqvgqmblZdgyNfcp+CrmDkpk=";
      }
    );
    "det_500m.onnx" = (
      fetchurl {
        url = "https://huggingface.co/deepghs/insightface/resolve/main/buffalo_s/det_500m.onnx?download=true";
        hash = "sha256-XkRH9QJFu9eWa9bA+lKTjGFHSgTsfe9IdTZoqdi06jo=";
      }
    );
    "w600k_mbf.onnx" = (
      fetchurl {
        url = "https://huggingface.co/deepghs/insightface/resolve/main/buffalo_s/w600k_mbf.onnx?download=true";
        hash = "sha256-nMbkp18OK/CxrtlFePFE0VF181e9wF6BXlxKArMZ608=";
      }
    );
  };

  # See: https://github.com/julyx10/lap/blob/main/scripts/download_ffmpeg_sidecar.sh
  ffmpeg_filename =
    {
      x86_64-linux = {
        ffmpeg = "ffmpeg-x86_64-unknown-linux-gnu";
        ffprobe = "ffprobe-x86_64-unknown-linux-gnu";
      };
      aarch64-linux = {
        ffmpeg = "ffmpeg-aarch64-unknown-linux-gnu";
        ffprobe = "ffprobe-aarch64-unknown-linux-gnu";
      };
    }
    .${stdenv.hostPlatform.system};
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lap";
  version = "0.3.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "julyx10";
    repo = "lap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k71kci6XYWJhw6FuUE73kQOmKSeCdoYr9qt2qHnLe6Y=";
    fetchSubmodules = true;
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-bBKlwAQ8IEIxi8w60vIXKRckNSzv1CuGW4lbaTM0QYg=";

  pnpmRoot = "src-vite";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    sourceRoot = "${finalAttrs.src.name}/src-vite";
    hash = "sha256-JCSxLecYpp1FLfsh4z67BkYnIr7hy0U20f3z4WXTBKQ=";
  };

  postUnpack = ''
    # Remove bundled libheif and libde265; we use system libraries instead
    rm -r $sourceRoot/src-tauri/third_party/libheif
    rm -r $sourceRoot/src-tauri/third_party/libde265
  '';

  nativeBuildInputs = [
    cmake
    cargo-tauri.hook
    nodejs
    pnpm
    pnpmConfigHook
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    atk
    glib
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-libav
    libheif
    libde265
    onnxruntime
    openssl
    webkitgtk_4_1
  ];

  preBuild = ''
    # Lowercase binary name to match the executable name
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"com.julyx10.lap"' '"com.julyx10.lap", "mainBinaryName": "lap"'
    # Fix path to vite source directory
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '--dir ../src-vite' '--dir src-vite'
    # Disable updater as it requires a private key
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true,' '"createUpdaterArtifacts": false,'

    # Install ffmpeg binaries
    install -Dm 755 ${lib.getExe' ffmpeg "ffmpeg"} ./src-tauri/resources/ffmpeg/${ffmpeg_filename.ffmpeg}
    install -Dm 755 ${lib.getExe' ffmpeg "ffprobe"} ./src-tauri/resources/ffmpeg/${ffmpeg_filename.ffprobe}
  ''
  # Install models
  + lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      filename: model: "install -Dm 644 ${model} ./src-tauri/resources/models/${filename}"
    ) models
  );

  env.LAP_SYSTEM_LIBHEIF = "1";

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Offline-first photo manager for large local libraries";
    homepage = "https://julyx10.github.io/lap/";
    changelog = "https://github.com/julyx10/lap/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ philipdb ];
    mainProgram = "lap";
    platforms = lib.platforms.linux;
  };
})
