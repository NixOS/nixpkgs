{ lib
, config
, stdenv
, fetchFromGitHub
, cmake
, qt6
, fmt
, shaderc
, vulkan-headers
, wayland
, cudaSupport ? config.cudaSupport
, cudaPackages ? { }
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpt4all";
  version = "2.8.0";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    hash = "sha256-aSz37+1K26Xizf4cpV45a2DnSsl959VQok/ppFRk/hs=";
    owner = "nomic-ai";
    repo = "gpt4all";
    rev = "v${finalAttrs.version}";
  };

  sourceRoot = "${finalAttrs.src.name}/gpt4all-chat";

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    fmt
    qt6.qtwayland
    qt6.qtquicktimeline
    qt6.qtsvg
    qt6.qthttpserver
    qt6.qtwebengine
    qt6.qt5compat
    shaderc
    vulkan-headers
    wayland
  ] ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cccl.dev
        cuda_cudart.dev
        cuda_cudart.lib
        cuda_cudart.static
        libcublas.dev
        libcublas.lib
      ]);

  cmakeFlags = [
    "-DKOMPUTE_OPT_USE_BUILT_IN_VULKAN_HEADER=OFF"
    "-DKOMPUTE_OPT_DISABLE_VULKAN_VERSION_CHECK=ON"
    "-DKOMPUTE_OPT_USE_BUILT_IN_FMT=OFF"
  ] ++ lib.optionals (!cudaSupport) [
    "-DLLMODEL_CUDA=OFF"
  ];

  postInstall = ''
    rm -rf $out/include
    rm -rf $out/lib/*.a
    mv $out/bin/chat $out/bin/${finalAttrs.meta.mainProgram}
    install -m 444 -D $src/gpt4all-chat/flatpak-manifest/io.gpt4all.gpt4all.desktop $out/share/applications/io.gpt4all.gpt4all.desktop
    install -m 444 -D $src/gpt4all-chat/icons/logo.svg $out/share/icons/hicolor/scalable/apps/io.gpt4all.gpt4all.svg
    substituteInPlace $out/share/applications/io.gpt4all.gpt4all.desktop \
      --replace-fail 'Exec=chat' 'Exec=${finalAttrs.meta.mainProgram}'
  '';

  meta = {
    changelog = "https://github.com/nomic-ai/gpt4all/releases/tag/v${finalAttrs.version}";
    description = "Free-to-use, locally running, privacy-aware chatbot. No GPU or internet required";
    homepage = "https://github.com/nomic-ai/gpt4all";
    license = lib.licenses.mit;
    mainProgram = "gpt4all";
    maintainers = with lib.maintainers; [ drupol polygon ];
  };
})
