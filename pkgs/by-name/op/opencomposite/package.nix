{
  cmake,
  fetchFromGitLab,
  glm,
  jsoncpp,
  lib,
  libGL,
  nix-update-script,
  openxr-loader,
  python3,
  stdenv,
  vulkan-headers,
  vulkan-loader,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencomposite";
  version = "1.0.1473";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-kwu8eM/rQBcZfs91loh7QAB46a01F9n5Xm1DmMd53MQ=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    glm
    jsoncpp
    libGL
    vulkan-headers
    vulkan-loader
    xorg.libX11
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-error=format-security")
    # See https://gitlab.com/znixian/OpenOVR/-/issues/416
    (lib.cmakeBool "USE_SYSTEM_OPENXR" false)
    (lib.cmakeBool "USE_SYSTEM_GLM" true)
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/opencomposite
    cp -r bin/ $out/lib/opencomposite
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reimplementation of OpenVR, translating calls to OpenXR";
    homepage = "https://gitlab.com/znixian/OpenOVR";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ Scrumplex ];
    # This can realistically only work on systems that support OpenXR Loader
    inherit (openxr-loader.meta) platforms;
  };
})
