{
  lib,
  stdenv,
  fetchgit,
  cmake,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsfg-vk";
  version = "2.0.0";

  src = fetchgit {
    url = "https://git.lsfg-vk.dev/lsfg-vk.git";
    tag = finalAttrs.version;
    hash = "sha256-vp0/adJdVV73C2RFjcEE90KjWiZJQhiqqOlYQ89RG+Y=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vulkan-headers
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LSFGVK_LAYER_LIBRARY_PATH" "${placeholder "out"}/lib/liblsfg-vk-layer.so")
    (lib.cmakeBool "LSFGVK_MANAGED" true)
  ];

  /*
    Installed lsfg-vk-layer version: terminate called after throwing an instance of 'std::runtime_error'
    what():  Failed to load vulkan library!
  */
  postFixup = ''
    patchelf --add-rpath "${lib.getLib vulkan-loader}/lib" "$out/bin/lsfg-vk-cli"
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Vulkan layer for frame generation (Requires owning Lossless Scaling)";
    homepage = "https://lsfg-vk.dev/";
    license = lib.licenses.cc-by-nc-nd-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      Gliczy
      pabloaul
    ];
    mainProgram = "lsfg-vk-cli";
  };
})
