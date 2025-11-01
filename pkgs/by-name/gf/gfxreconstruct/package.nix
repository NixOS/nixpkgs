{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  makeWrapper,
  pkg-config,
  python3,
  wayland,
  libX11,
  libxcb,
  lz4,
  vulkan-loader,
  xcbutilkeysyms,
  zlib,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "gfxreconstruct";
  version = "unstable-2025-10-09";

  src = fetchFromGitHub {
    owner = "LunarG";
    repo = "gfxreconstruct";
    rev = "6cf50dc987abd4777904b52edcc7d3d93bdfa265";
    hash = "sha256-Vi5dQXrm/zkUP6Y460KlXqqAtZ43Vtp4yOde4ZfYnO4=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libX11
    libxcb
    lz4
    python3
    wayland
    xcbutilkeysyms
    zlib
    zstd
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  # The python script searches in subfolders, but we want to search in the same bin directory
  prePatch = ''
    substituteInPlace tools/gfxrecon/gfxrecon.py \
      --replace "scriptdir, '..', cmd" 'scriptdir'
  '';

  # Fix the paths to load the layer.
  # Also remove the .py suffix on files so that gfxrecon
  # does not try to start the wrapper bash scripts with python.
  postInstall = ''
    substituteInPlace $out/share/vulkan/explicit_layer.d/VkLayer_gfxreconstruct.json \
      --replace 'libVkLayer_gfxreconstruct.so' "$out/lib/libVkLayer_gfxreconstruct.so"
    for f in $out/bin/*.py; do
      mv -- "$f" "''${f%%.py}"
    done
    wrapProgram $out/bin/gfxrecon-capture-vulkan \
      --prefix VK_ADD_LAYER_PATH : "$out/share/vulkan/explicit_layer.d"
    wrapProgram $out/bin/gfxrecon-replay \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}

    # Remove unrelated files that got installed
    rm -r $out/lib/{cmake,pkgconfig}
  '';

  meta = {
    description = "Graphics API Capture and Replay Tools";
    homepage = "https://github.com/LunarG/gfxreconstruct/";
    changelog = "https://github.com/LunarG/gfxreconstruct/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Flakebi ];
    platforms = lib.platforms.linux;
  };
}
