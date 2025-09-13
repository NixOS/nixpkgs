{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  qt6,
  duckx,
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
  version = "3.10.0";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    hash = "sha256-OAD/uSCL/3OXmYVG+iGJK4zD2s0dDaPf59DF23AbSFU=";
    owner = "nomic-ai";
    repo = "gpt4all";
    tag = "v${finalAttrs.version}";
  };

  embed_model = fetchurl {
    url = "https://gpt4all.io/models/gguf/nomic-embed-text-v1.5.f16.gguf";
    hash = "sha256-969vZoAvTfhu2hD+m7z8dcOVYr7Ujvas5xmiUc8cL9s=";
  };

  patches = [
    ./embedding-local.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "duckx::duckx QXlsx" "duckx QXlsx"
  '';

  sourceRoot = "${finalAttrs.src.name}/gpt4all-chat";

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ];

  buildInputs = [
    duckx
    fmt
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qthttpserver
    qt6.qtsvg
    qt6.qttools
    qt6.qtwayland
    qt6.qtwebengine
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

  cmakeFlags = [
    (lib.cmakeBool "KOMPUTE_OPT_USE_BUILT_IN_VULKAN_HEADER" false)
    (lib.cmakeBool "KOMPUTE_OPT_DISABLE_VULKAN_VERSION_CHECK" true)
    (lib.cmakeBool "KOMPUTE_OPT_USE_BUILT_IN_FMT" false)

    # https://github.com/NixOS/nixpkgs/issues/298997
    # https://github.com/nomic-ai/gpt4all/issues/3468
    (lib.cmakeBool "LLMODEL_KOMPUTE" false)
  ]
  ++ lib.optionals (!cudaSupport) [
    (lib.cmakeBool "LLMODEL_CUDA" false)
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
      titaniumtown
    ];
  };
})
