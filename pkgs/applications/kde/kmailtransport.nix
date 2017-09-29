{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-mime, cyrus_sasl, kcmutils, ki18n, kio, kmime, kwallet,
}:

mkDerivation {
  name = "kmailtransport";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ akonadi kcmutils ki18n kio ];
  propagatedBuildInputs = [ akonadi-mime cyrus_sasl kmime kwallet ];
  outputs = [ "out" "dev" ];
}
