{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  cyrus_sasl, kcoreaddons, ki18n, kio, kmime
}:

mkDerivation {
  pname = "kimap";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ ki18n kio ];
  propagatedBuildInputs = [ cyrus_sasl kcoreaddons kmime ];
  outputs = [ "out" "dev" ];
}
