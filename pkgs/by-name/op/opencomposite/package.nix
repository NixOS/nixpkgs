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
  version = "0-unstable-2024-12-20";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "b9069698f2ed420a5f1ae783c02b88fbde775fc2";
    fetchSubmodules = true;
    hash = "sha256-ow10yTvZyB5fLTwgxspjS/atxK1QTGcLJtkWpQgYaeQ=";
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
    # This can realistically only work on systems that support OpenXR Loader
    inherit (openxr-loader.meta) platforms;
  };
}
