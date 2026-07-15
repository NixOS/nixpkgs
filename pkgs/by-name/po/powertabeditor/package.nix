{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,
  pkg-config,
  doctest,

  boost,
  qt6,
  nlohmann_json,
  rtmidi,
  pugixml,
  minizip,

  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "powertabeditor";
  version = "2.0.22";

  src = fetchFromGitHub {
    owner = "powertab";
    repo = "powertabeditor";
    tag = finalAttrs.version;
    hash = "sha256-VqTtzAWNghMoiYH0QVerQRdqVltZUz0Wgs5t3SvjyN4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    doctest
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    qt6.qtbase
    qt6.qttools
    nlohmann_json
    rtmidi
    pugixml
    minizip
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "View and edit guitar tablature";
    homepage = "https://powertab.github.io/";
    changelog = "https://github.com/powertab/powertabeditor/blob/refs/tags/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "powertabeditor";
  };
})
