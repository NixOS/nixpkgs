{
  lib,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  llvmPackages,
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "lsfg-vk";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "PancakeTAS";
    repo = "lsfg-vk";
    tag = "v${version}";
    hash = "sha256-hWpuPH7mKbeMaLaRUwtlkNLy4lOnJEe+yd54L7y2kV0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace VkLayer_LS_frame_generation.json \
      --replace-fail "liblsfg-vk.so" "$out/lib/liblsfg-vk.so"
  '';

  nativeBuildInputs = [
    llvmPackages.clang-tools
    llvmPackages.libllvm
    cmake
  ];

  buildInputs = [
    vulkan-headers
  ];

  meta = {
    description = "Vulkan layer for frame generation (Requires owning Lossless Scaling)";
    homepage = "https://github.com/PancakeTAS/lsfg-vk/";
    changelog = "https://github.com/PancakeTAS/lsfg-vk/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pabloaul ];
  };
}
