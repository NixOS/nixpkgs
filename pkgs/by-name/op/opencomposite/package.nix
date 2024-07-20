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
  version = "0-unstable-2024-06-12";

  src = fetchFromGitLab {
    owner = "znixian";
    repo = "OpenOVR";
    rev = "de1658db7e2535fd36c2e37fa8dd3d756280c86f";
    hash = "sha256-xyEiuEy3nt2AbF149Pjz5wi/rkTup2SgByR4DrNOJX0=";
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
  ];

  # NOTE: `cmakeFlags` will get later tokenized by bash and there is no way
  # of inserting a flag value with a space in it (inserting `"` or `'` won't help).
  # https://discourse.nixos.org/t/cmakeflags-and-spaces-in-option-values/20170/2
  preConfigure = ''
    cmakeFlagsArray+=(
      "-DCMAKE_CXX_FLAGS=-DGLM_ENABLE_EXPERIMENTAL -Wno-error=format-security"
    )
  '';

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
