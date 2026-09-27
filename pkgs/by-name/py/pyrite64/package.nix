{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  makeWrapper,
  glm,
  libGL,
  vulkan-loader,
  vulkan-headers,
  libx11,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxcb,
  libxtst,
  wayland,
  wayland-protocols,
  libdecor,
  libxkbcommon,
  alsa-lib,
  udev,
  dbus,
  libpng,
  libjpeg,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pyrite64";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "HailToDodongo";
    repo = "pyrite64";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4IKcfccjS5d/KI4rS9CjcRwfWAo/WLWzIXI5BCbhM7U=";
    fetchSubmodules = true;
    fetchLFS = true;
  };

  postPatch = ''
    # The upstream CMakeLists.txt redirects the binary to CMAKE_SOURCE_DIR (the source root).
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'set_target_properties(pyrite64 PROPERTIES RUNTIME_OUTPUT_DIRECTORY "''${CMAKE_SOURCE_DIR}")' \
        ""

    # Replace vendored glm add_subdirectory with find_package so the nixpkgs glm package is used.
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'add_subdirectory(vendored/glm EXCLUDE_FROM_ALL)' \
        'find_package(glm REQUIRED)'

    substituteInPlace src/editor/pages/editorScene.cpp \
      --replace-fail \
        'if(tooltip)ImGui::SetTooltip(tooltip);' \
        'if(tooltip)ImGui::SetTooltip("%s", tooltip);'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    glm
    libGL
    vulkan-loader
    vulkan-headers
    libx11
    libxcursor
    libxext
    libxfixes
    libxi
    libxinerama
    libxrandr
    libxrender
    libxscrnsaver
    libxcb
    libxtst
    wayland
    wayland-protocols
    libdecor
    libxkbcommon
    alsa-lib
    udev
    dbus
    libpng
    libjpeg
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 pyrite64 -t "$out/share/pyrite64"
    cp -r "$src/data" "$out/share/pyrite64/data"
    cp -r "$src/n64"  "$out/share/pyrite64/n64"

    runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --add-rpath "${
        lib.makeLibraryPath [
          libx11
          libxcursor
          libxext
          libxfixes
          libxi
          libxinerama
          libxrandr
          libxrender
          libxscrnsaver
          libxcb
          libxtst
          wayland
          libdecor
          libxkbcommon
          alsa-lib
          dbus
        ]
      }" \
      "$out/share/pyrite64/pyrite64"

    makeWrapper "$out/share/pyrite64/pyrite64" "$out/bin/pyrite64" \
      --chdir "$out/share/pyrite64" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          vulkan-loader
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "N64 Game-Engine and Editor using libdragon & tiny3d";
    homepage = "https://github.com/HailToDodongo/pyrite64";
    changelog = "https://github.com/HailToDodongo/pyrite64/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ZZBaron ];
    platforms = lib.platforms.linux;
    mainProgram = "pyrite64";
  };
})
