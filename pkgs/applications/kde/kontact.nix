{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  qtwebengine,
  kcmutils, kcrash, kdbusaddons, kparts, kwindowsystem,
  akonadi, grantleetheme, kontactinterface, kpimtextedit,
  mailcommon, libkdepim, pimcommon
}:

mkDerivation {
  pname = "kontact";
  meta = {
    homepage = "https://apps.kde.org/kontact/";
    description = "Personal information manager";
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    qtwebengine
    kcmutils kcrash kdbusaddons kparts kwindowsystem
    akonadi grantleetheme kontactinterface kpimtextedit
    mailcommon libkdepim pimcommon
  ];
}
