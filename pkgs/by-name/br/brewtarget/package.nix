{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
  boost,
  pandoc,
  pkg-config,
  xercesc,
  xalanc,
  qt6,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brewtarget";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "Brewtarget";
    repo = "brewtarget";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/BEVnAtuwDnJXra9EAMD3LhA/93nFJ5ObCSgSy3CJnk=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # 3 sed statements from below derived from AUR
    # Disable boost-stacktrace_backtrace, requires an optional boost lib that's only built in Debianland
    sed -i "/boostModules += 'stacktrace_backtrace'/ {N;N;d}" meson.build
    # Make libbacktrace not required, we're not running the bt script
    sed -i "/compiler\.find_library('backtrace'/ {n;s/true/false/}" meson.build
    # Disable static linking
    sed -i 's/static : true/static : false/g' meson.build
  '';

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    wrapGAppsHook3
    pandoc
  ];

  buildInputs = [
    boost
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qttools
    xercesc
    xalanc
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Open source beer recipe creation tool";
    mainProgram = "brewtarget";
    homepage = "https://www.brewtarget.beer";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      avnik
      mmahut
      ilkecan
    ];
  };
})
