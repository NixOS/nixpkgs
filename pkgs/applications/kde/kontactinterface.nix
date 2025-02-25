{
  mkDerivation,
  lib,
  kdepimTeam,
  extra-cmake-modules,
  kdoctools,
  kiconthemes,
  kparts,
  kwindowsystem,
  kxmlgui,
  qtx11extras,
}:

mkDerivation {
  pname = "kontactinterface";
  meta = {
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kiconthemes
    kwindowsystem
    kxmlgui
    qtx11extras
  ];
  propagatedBuildInputs = [ kparts ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$out/include/KF5"
  '';
}
