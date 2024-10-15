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
}:

stdenv.mkDerivation {
  pname = "opencomposite";
  version = "0-unstable-2024-10-02";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "f969a972e9a151de776fa8d1bd6e67056f0a5d5d";
    fetchSubmodules = true;
    hash = "sha256-3Aar7HGhn9nd/EtJoeUbQTkUR16jx946ZXMNDOXSdfQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    glm
    jsoncpp
    libGL
    python3
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
  };
}
