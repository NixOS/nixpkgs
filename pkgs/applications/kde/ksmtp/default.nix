{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kcoreaddons, kio, kmime, cyrus_sasl
}:

mkDerivation {
  pname = "ksmtp";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcoreaddons kio kmime ];
  propagatedBuildInputs = [ cyrus_sasl ];
}
