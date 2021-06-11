{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kdbusaddons, kcrash, kbookmarks, kiconthemes, kio, kpimtextedit,
  kmailtransport, libksieve, pimcommon, qtkeychain, libsecret
}:

mkDerivation {
  pname = "pim-sieve-editor";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kdbusaddons kcrash kbookmarks kiconthemes kio kpimtextedit kmailtransport
    libksieve pimcommon qtkeychain libsecret
  ];
}
