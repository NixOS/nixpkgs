{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  qtwebengine,
  kcmutils, kcrash, kdbusaddons, kparts, kwindowsystem,
  akonadi, grantleetheme, kontactinterface, kpimtextedit,
  mailcommon, libkdepim, pimcommon,
  # some PIM applications embedded by Kontact need to call external executables
  pimExternalApplications
}:

mkDerivation {
  pname = "kontact";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    qtwebengine
    kcmutils kcrash kdbusaddons kparts kwindowsystem
    akonadi grantleetheme kontactinterface kpimtextedit
    mailcommon libkdepim pimcommon
  ]
  ++ pimExternalApplications.kmailApplications;
  # create wrapper for being able to call external executables,
  # please concatenate the external dependencies of all PIM components specified in `pimExternalApplications`
  postFixup = ''
    wrapProgram "$out/bin/kontact" \
    --prefix PATH : "${lib.makeBinPath ([] ++ pimExternalApplications.kmailApplications)}"
    '';
}
