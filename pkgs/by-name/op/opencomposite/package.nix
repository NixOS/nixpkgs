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

, nix-update-script
}:

stdenv.mkDerivation {
  pname = "opencomposite";
  version = "xrGetSystem-regression-unstable-2024-05-08";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "5ddd6024efafa82c7a432c9dd8a67e3d5c3f9b38";
    hash = "sha256-m6Xhi6xlDWiVqtYyxpQP2vp5JsB2EKsoXkmd0IYtPQ8=";
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
    "-DUSE_SYSTEM_OPENXR=ON"
    "-DUSE_SYSTEM_GLM=ON"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/opencomposite
    cp -r bin/ $out/lib/opencomposite
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=openxr" ];
  };

  meta = with lib; {
    description = "Reimplementation of OpenVR, translating calls to OpenXR";
    homepage = "https://gitlab.com/znixian/OpenOVR";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ Scrumplex ];
  };
}
