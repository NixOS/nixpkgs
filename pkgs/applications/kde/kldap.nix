{
  kdeApp, lib, kdeWrapper,
  extra-cmake-modules, kdoctools,
  cyrus_sasl, kio, kmbox, openldap
}:
kdeApp {
  name = "kldap";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = [ lib.maintainers.vandenoever ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    cyrus_sasl kio kmbox openldap
  ];
}
