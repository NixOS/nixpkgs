{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  libx11,
  libxxf86vm,
  libxrandr,
  vulkan-headers,
  libGL,
  vulkan-loader,
  wayland,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openxr-loader";
  version = "1.1.54";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenXR-SDK-Source";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-7aip1ymZqQ7XQottD9jVb7SBPAlGaj6e27tH6aXYc2I=";
  };

  nativeBuildInputs = [
    cmake
    python3
    pkg-config
  ];
  buildInputs = [
    vulkan-headers
    libGL
    vulkan-loader
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libx11
    libxxf86vm
    libxrandr
    wayland
  ];

  cmakeFlags = [ "-DBUILD_TESTS=ON" ];

  outputs = [
    "out"
    "dev"
  ]
  # layers don't currently build on darwin
  # https://github.com/KhronosGroup/OpenXR-SDK-Source/issues/582
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) "layers";

  # https://github.com/KhronosGroup/OpenXR-SDK-Source/issues/305
  postPatch = ''
    substituteInPlace src/loader/openxr.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p "$layers/share"
    mv "$out/share/openxr" "$layers/share"
    # Use absolute paths in manifests so no LD_LIBRARY_PATH shenanigans are necessary
    for file in "$layers/share/openxr/1/api_layers/explicit.d/"*; do
        substituteInPlace "$file" --replace '"library_path": "lib' "\"library_path\": \"$layers/lib/lib"
    done
    mkdir -p "$layers/lib"
    mv "$out/lib/libXrApiLayer"* "$layers/lib"
  '';

  meta = {
    description = "Khronos OpenXR loader";
    homepage = "https://www.khronos.org/openxr";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ralith ];
  };
})
