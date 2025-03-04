{
  cmake,
  fetchFromGitLab,
  glm,
  jsoncpp,
  lib,
  libGL,
  python3,
  stdenv,
  unstableGitUpdater,
  vulkan-headers,
  vulkan-loader,
  xorg,
  openxr-loader,
}:

stdenv.mkDerivation {
  pname = "opencomposite";
  version = "0-unstable-2025-03-01";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "578a1a5c57204e7db31299351c8e312ead9ba7c4";
    fetchSubmodules = true;
    hash = "sha256-LTC/RJdi4saj5hVli23GUm+ytKPv/Z94WHlo5s+tMeY=";
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

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
    branch = "openxr";
  };

  meta = {
    description = "Reimplementation of OpenVR, translating calls to OpenXR";
    homepage = "https://gitlab.com/znixian/OpenOVR";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ Scrumplex ];
    # This can realistically only work on systems that support OpenXR Loader
    inherit (openxr-loader.meta) platforms;
  };
}
