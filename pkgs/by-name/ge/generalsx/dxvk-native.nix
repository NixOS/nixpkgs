{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
  glslang,
  spirv-headers,
  pkg-config,
  sdl3,
  vulkan-headers,
}:

let
  libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dxvk-native";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "fbraz3";
    repo = "dxvk";
    rev = "46a3bc018bcae408d49d3c500e4e536a11f6789a";
    fetchSubmodules = true;
    hash = "sha256-e08D+RzGeguOXt+rB5lwLX8jwHscQsPZoK0LagPYh/g=";
  };

  postPatch = ''
    substituteInPlace subprojects/libdisplay-info/tool/gen-search-table.py \
      --replace-fail "/usr/bin/env python3" "${lib.getBin python3}/bin/python3"
  '';

  nativeBuildInputs = [
    glslang
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    sdl3
    spirv-headers
    vulkan-headers
  ];

  mesonFlags = [
    (lib.mesonOption "dxvk_native_wsi" "sdl3")
    (lib.mesonBool "enable_d3d8" true)
    (lib.mesonBool "enable_d3d9" true)
    (lib.mesonBool "enable_d3d10" false)
    (lib.mesonBool "enable_d3d11" false)
    (lib.mesonBool "enable_dxgi" false)
    (lib.mesonBool "build_id" false)
  ];

  installPhase = ''
    runHook preInstall
    mesonInstallPhase
    mkdir -p $out/x64 $out/include/native
    mv $out/lib/*.${libExt}* $out/x64/
    cp -r ${finalAttrs.src}/include/native $out/include/
    runHook postInstall
  '';

  meta = {
    description = "Vulkan-based translation layer for Direct3D 8/9, built natively (macOS fork)";
    homepage = "https://github.com/fbraz3/dxvk";
    license = lib.licenses.zlib;
    platforms = [ "aarch64-darwin" ];
  };
})
