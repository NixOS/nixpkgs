{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  cyrus_sasl, ki18n, kio, kmbox, openldap
}:

mkDerivation {
  pname = "kldap";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ ki18n kio kmbox ];
  propagatedBuildInputs = [ cyrus_sasl openldap ];
  outputs = [ "out" "dev" ];
}
