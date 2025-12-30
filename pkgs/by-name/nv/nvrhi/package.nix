{
  cmake,
  directx-headers,
  fetchFromGitHub,
  lib,
  stdenv,
  vulkan-headers,
  d3d11 ? stdenv.hostPlatform.isWindows,
  d3d12 ? stdenv.hostPlatform.isWindows,
  validation ? true,
  vulkan ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation {
  pname = "nvrhi";
  version = "0-unstable-2025-12-16";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "NVIDIA-RTX";
    repo = "NVRHI";
    rev = "92a13688a5186ca76612517234490cfe72f3e7d1";
    hash = "sha256-8WzGgXOcYTXNSJyRYtMl/dIbe7Qrq33/MJz6MeoonWs=";
  };

  patches = [
    # Required; upstream hardcodes the expectation that Vulkan/DirectX headers be included as a submodule.
    ./patches/0001-Fix-CMakeLists.patch
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals vulkan [
    vulkan-headers
  ]
  ++ lib.optionals (d3d11 || d3d12) [
    directx-headers
  ];

  cmakeFlags = [
    (lib.cmakeBool "NVRHI_BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "NVRHI_WITH_VALIDATION" validation)
    (lib.cmakeBool "NVRHI_WITH_VULKAN" vulkan)
    (lib.cmakeBool "NVRHI_WITH_DX11" d3d11)
    (lib.cmakeBool "NVRHI_WITH_DX12" d3d12)
  ];

  meta = {
    description = "NVIDIA Hardware Rendering Interface";
    homepage = "https://github.com/NVIDIA-RTX/NVRHI";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bearfm ];
    platforms = lib.platforms.linux ++ lib.platforms.windows;
  };
}
