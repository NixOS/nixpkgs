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
  version = "unstable-2024-03-04";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "1bfdf67358add5f573efedbec1fa65d18b790e0e";
    hash = "sha256-qF5oMI9B5a1oE2gQb/scbom/39Efccja0pTPHHaHMA8=";
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
