{
  lib,
  stdenv,
  fetchFromGitHub,
  applyPatches,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.4.321.0";

  # Several downstream derivations consume `spirv-headers.src`; apply
  # relevant patches here rather than in the main derivation.
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "SPIRV-Headers";
      rev = "vulkan-sdk-${version}";
      hash = "sha256-LRjMy9xtOErbJbMh+g2IKXfmo/hWpegZM72F8E122oY=";
    };

    patches = [
      # Backport commit missing from 1.4.321.0 that is required for
      # libclc 21 to build.
      (fetchpatch {
        name = "spirv-headers-add-SPV_INTEL_function_variants.patch";
        url = "https://github.com/KhronosGroup/SPIRV-Headers/commit/9e3836d7d6023843a72ecd3fbf3f09b1b6747a9e.patch";
        hash = "sha256-wADjOxcIXHjF735w0wUAeDbVEJR8d6UHrHS9CiOEUrA=";
      })
    ];
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
