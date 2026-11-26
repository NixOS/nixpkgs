{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
  curl,
  nlohmann_json,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "obs-advanced-masks";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-advanced-masks";
    tag = "v${version}";
    hash = "sha256-WlFLlVXrxCYVE4SxvwemjgMZXI8NGshl/sX7034qYK8=";
  };

  buildInputs = [
    curl
    obs-studio
    qt6.qtbase
    qt6.qtsvg
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_FRONTEND_API" true)
    (lib.cmakeBool "ENABLE_QT" true)
    # Use our nlohmann_json instead of downloading it at configure time
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json.src}")
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Advanced Masking Plugin for OBS";
    homepage = "https://github.com/FiniteSingularity/obs-advanced-masks";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ rytswd ];
    mainProgram = "obs-advanced-masks";
    platforms = lib.platforms.linux;
  };
}
