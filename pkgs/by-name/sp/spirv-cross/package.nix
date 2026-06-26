{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-cross";
  version = "1.4.350.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-JdVAS5uVSfe0mOGtyodkgmvgD4of9Amq8PbDSAtgaXc=";
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
    changelog = "https://github.com/KhronosGroup/SPIRV-Cross/releases/tag/vulkan-sdk-${finalAttrs.version}";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Flakebi ];
    mainProgram = "spirv-cross";
  };
})
