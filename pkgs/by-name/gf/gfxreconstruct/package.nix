{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  makeWrapper,
  pkg-config,
  python3,
  wayland,
  libx11,
  libxcb,
  lz4,
  vulkan-loader,
  libxcb-keysyms,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gfxreconstruct";
  version = "1.0.4-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "LunarG";
    repo = "gfxreconstruct";
    rev = "41c7f2d964544813df5988d9689189f8520b1e2e";
    hash = "sha256-xtiNxKU0gJURN4FQBZyEX2VaDqvdiMoyDJZOoMafAgM=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libx11
    libxcb
    lz4
    python3
    wayland
    libxcb-keysyms
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
      --replace-fail "scriptdir, '..', cmd" 'scriptdir'
  '';

  # Fix the paths to load the layer.
  # Also remove the .py suffix on files so that gfxrecon
  # does not try to start the wrapper bash scripts with python.
  postInstall = ''
    substituteInPlace $out/share/vulkan/explicit_layer.d/VkLayer_gfxreconstruct.json \
      --replace-fail 'libVkLayer_gfxreconstruct.so' "$out/lib/libVkLayer_gfxreconstruct.so"
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Flakebi ];
    platforms = lib.platforms.linux;
  };
})
