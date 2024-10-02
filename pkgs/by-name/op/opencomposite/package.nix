{
  cmake,
  fetchFromGitLab,
  glm,
  jsoncpp,
  lib,
  libGL,
  openxr-loader,
  python3,
  stdenv,
  unstableGitUpdater,
  vulkan-headers,
  vulkan-loader,
  xorg,
}:

stdenv.mkDerivation {
  pname = "opencomposite";
  version = "0-unstable-2024-09-13";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "f8db7aa35831753f00215a2d9ba7197a80d7bacd";
    hash = "sha256-3fqh7Kth5XFcDsJUMmR2af+r5QPW3/mAsEauGUXaWq8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    glm
    jsoncpp
    libGL
    openxr-loader
    python3
    vulkan-headers
    vulkan-loader
    xorg.libX11
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-error=format-security")
    (lib.cmakeBool "USE_SYSTEM_OPENXR" true)
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
