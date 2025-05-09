{
  lib,
  stdenv,
  fetchFromGitHub,
  smartmontools,
  cmake,
  gtkmm3,
  pkg-config,
  wrapGAppsHook3,
  pcre-cpp,
  adwaita-icon-theme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsmartcontrol";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "ashaduri";
    repo = "gsmartcontrol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eLzwFZ1PYqijFTxos9Osf7A2v4C8toM+TGV4/bU82NE=";
  };

  postPatch = ''
    substituteInPlace data/gsmartcontrol.in.desktop \
      --replace-fail "@CMAKE_INSTALL_FULL_BINDIR@/" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    pcre-cpp
    adwaita-icon-theme
  ];

  enableParallelBuilding = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ smartmontools ]}"
    )
  '';

  meta = {
    description = "Hard disk drive health inspection tool";
    longDescription = ''
      GSmartControl is a graphical user interface for smartctl (from
      smartmontools package), which is a tool for querying and controlling
      SMART (Self-Monitoring, Analysis, and Reporting Technology) data on
      modern hard disk drives.

      It allows you to inspect the drive's SMART data to determine its health,
      as well as run various tests on it.
    '';
    homepage = "https://gsmartcontrol.shaduri.dev";
    mainProgram = "gsmartcontrol";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qknight ];
    platforms = lib.platforms.linux;
  };
})
