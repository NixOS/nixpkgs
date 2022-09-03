{
  mkDerivation, fetchpatch, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  boost, gpgme, kcmutils, kdbusaddons, kiconthemes, kitemmodels, kmime,
  knotifications, kwindowsystem, kxmlgui, libkleo, kcrash
}:

mkDerivation {
  pname = "kleopatra";

  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/pim/kleopatra/-/commit/87d8b00d4b2286489d5fadc9cfa07f1d721cdfe3.patch";
      sha256 = "sha256-s1tXB7h0KtFwwZHx8rhpI0nLZmwhWAiraHEF3KzncMc=";
    })
  ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [
    boost gpgme kcmutils kdbusaddons kiconthemes kitemmodels kmime
    knotifications kwindowsystem kxmlgui libkleo kcrash
  ];

  meta = {
    homepage = "https://apps.kde.org/kleopatra/";
    description = "Certificate manager and unified crypto GUI";
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
}
