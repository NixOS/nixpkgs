{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-cross";
  version = "1.4.341.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-F3/j2+B/qv3sDiOiOy1OhR9G+DnM7I4LJqljZXL4S7Q=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isUnix [
    (lib.cmakeBool "SPIRV_CROSS_SHARED" true)
  ];

  postFixup = ''
    substituteInPlace $out/lib/pkgconfig/*.pc \
      --replace '=''${prefix}//' '=/'
  '';

  meta = {
    description = "Tool designed for parsing and converting SPIR-V to other shader languages";
    homepage = "https://github.com/KhronosGroup/SPIRV-Cross";
    changelog = "https://github.com/KhronosGroup/SPIRV-Cross/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Flakebi ];
    mainProgram = "spirv-cross";
  };
})
