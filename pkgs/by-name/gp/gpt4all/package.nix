{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  cmake,
  qt6,
  fmt,
  shaderc,
  vulkan-headers,
  wayland,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  autoAddDriverRunpath,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpt4all";
  version = "3.4.2";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    hash = "sha256-QzU22y6tt3UhazVSPcFuKejH4AV+mw7JExH61NtAKoM=";
    owner = "nomic-ai";
    repo = "gpt4all";
    rev = "v${finalAttrs.version}";
  };

  embed_model = fetchurl {
    url = "https://gpt4all.io/models/gguf/nomic-embed-text-v1.5.f16.gguf";
    hash = "sha256-969vZoAvTfhu2hD+m7z8dcOVYr7Ujvas5xmiUc8cL9s=";
  };

  patches = [
    ./embedding-local.patch
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/004-fix-build-with-qt-6.8.0.diff?h=gpt4all-chat&id=d14b12cb63fae95e578aa839a570189a23833051";
      sha256 = "3Zur9KFn45f4dgAzOF7p1q42IdLqXwioN4zMiBbWbVU=";
      # remove the `gpt4all-chat` part of the paths as sourceRoot is gpt4all-chat
      stripLen = 1;
    })
  ];

  sourceRoot = "${finalAttrs.src.name}/gpt4all-chat";

  nativeBuildInputs =
    [
      cmake
      qt6.wrapQtAppsHook
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
      autoAddDriverRunpath
    ];

  buildInputs =
    [
      fmt
      qt6.qtwayland
      qt6.qtquicktimeline
      qt6.qtsvg
      qt6.qthttpserver
      qt6.qtwebengine
      qt6.qt5compat
      qt6.qttools
      shaderc
      vulkan-headers
      wayland
    ]
    ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cccl
        cuda_cudart
        libcublas
      ]
    );

  cmakeFlags =
    [
      "-DKOMPUTE_OPT_USE_BUILT_IN_VULKAN_HEADER=OFF"
      "-DKOMPUTE_OPT_DISABLE_VULKAN_VERSION_CHECK=ON"
      "-DKOMPUTE_OPT_USE_BUILT_IN_FMT=OFF"
      "-DGGML_VULKAN=ON"
      "-DGGML_KOMPUTE=ON"
    ]
    ++ lib.optionals (!cudaSupport) [
      "-DLLMODEL_CUDA=OFF"
    ];

  postInstall = ''
    rm -rf $out/include
    rm -rf $out/lib/*.a
    mv $out/bin/chat $out/bin/${finalAttrs.meta.mainProgram}
    install -D ${finalAttrs.embed_model} $out/resources/nomic-embed-text-v1.5.f16.gguf
    install -m 444 -D $src/gpt4all-chat/flatpak-manifest/io.gpt4all.gpt4all.desktop $out/share/applications/io.gpt4all.gpt4all.desktop
    install -m 444 -D $src/gpt4all-chat/icons/nomic_logo.svg $out/share/icons/hicolor/scalable/apps/io.gpt4all.gpt4all.svg
    substituteInPlace $out/share/applications/io.gpt4all.gpt4all.desktop \
      --replace-fail 'Exec=chat' 'Exec=${finalAttrs.meta.mainProgram}'
  '';

  meta = {
    changelog = "https://github.com/nomic-ai/gpt4all/releases/tag/v${finalAttrs.version}";
    description = "Free-to-use, locally running, privacy-aware chatbot. No GPU or internet required";
    homepage = "https://github.com/nomic-ai/gpt4all";
    license = lib.licenses.mit;
    mainProgram = "gpt4all";
    maintainers = with lib.maintainers; [
      polygon
      titaniumtown
    ];
  };
})
