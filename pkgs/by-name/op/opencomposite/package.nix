{ lib
, stdenv
, fetchFromGitLab

, cmake

, glm
, libGL
, openxr-loader
, python3
, vulkan-headers
, vulkan-loader
, xorg

, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "opencomposite";
  version = "0-unstable-2024-06-01";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "49c4b89579fd49c5b40b72924d6593fcd47c5065";
    hash = "sha256-Aubf1tupyXzmff3ho/yKx9B3uJ8I0aoZi9zRV3A89Pc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    glm
    libGL
    openxr-loader
    python3
    vulkan-headers
    vulkan-loader
    xorg.libX11
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_OPENXR" true)
    (lib.cmakeBool "USE_SYSTEM_GLM" true)
    # debug logging macros cause format-security warnings
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-error=format-security")
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

  meta = with lib; {
    description = "Reimplementation of OpenVR, translating calls to OpenXR";
    homepage = "https://gitlab.com/znixian/OpenOVR";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ Scrumplex ];
  };
}
