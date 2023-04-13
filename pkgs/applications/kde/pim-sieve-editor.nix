{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kdbusaddons, kcrash, kbookmarks, kiconthemes, kio, kpimtextedit,
  kmailtransport,
  kuserfeedback,
  libksieve, pimcommon, qtkeychain, libsecret
}:

mkDerivation {
  pname = "pim-sieve-editor";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kdbusaddons kcrash kbookmarks kiconthemes kio kpimtextedit kmailtransport
    kuserfeedback
    libksieve pimcommon qtkeychain libsecret
  ];
}
