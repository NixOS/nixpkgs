{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, karchive, kcontacts, kcrash, kidentitymanagement, kio,
  kmailtransport, kwallet, mailcommon, mailimporter, messagelib
}:

mkDerivation {
  pname = "akonadi-import-wizard";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi karchive kcontacts kcrash kidentitymanagement kio
    kmailtransport kwallet mailcommon mailimporter messagelib
  ];
  outputs = [ "out" "dev" ];
}
