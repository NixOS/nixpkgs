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
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "LunarG";
    repo = "gfxreconstruct";
    tag = "v${version}";
    hash = "sha256-MuCdJoBFxKwDCOCltlU3oBS9elFS6F251dHjHcIb4Jg=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    # The CMakeLists.txt is actually 3.10 compatible, but it specifies 3.5 as `CMAKE_VERSION_MINIMUM`
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
  ];

  # Workaround for "error: ... class std::__cxx11::wstring_convert' is deprecated [-Werror=deprecated-declarations]"
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

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
