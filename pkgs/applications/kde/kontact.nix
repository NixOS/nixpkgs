{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  qtwebengine,
  kcmutils, kcrash, kdbusaddons, kparts, kwindowsystem,
  akonadi, grantleetheme, kdepim-apps-libs, kontactinterface, kpimtextedit,
  mailcommon, libkdepim
}:

mkDerivation {
  name = "kontact";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    qtwebengine
    kcmutils kcrash kdbusaddons kparts kwindowsystem
    akonadi grantleetheme kdepim-apps-libs kontactinterface kpimtextedit
    mailcommon libkdepim
  ];
}
