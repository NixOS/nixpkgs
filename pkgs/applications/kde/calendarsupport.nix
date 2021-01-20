{
  mkDerivation, lib, kdepimTeam, fetchpatch,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-calendar, akonadi-mime, akonadi-notes, kcalutils, kdepim-apps-libs,
  kholidays, kidentitymanagement, kmime, pimcommon, qttools,
}:

mkDerivation {
  pname = "calendarsupport";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  patches = [
    # Patch for Qt 5.15.2 until version 20.12.0
    (fetchpatch {
      url = "https://invent.kde.org/pim/calendarsupport/-/commit/b4193facb223bd5b73a65318dec8ced51b66adf7.patch";
      sha256 = "sha256:1da11rqbxxrl06ld3avc41p064arz4n6w5nxq8r008v8ws3s64dy";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-mime akonadi-notes kcalutils kdepim-apps-libs kholidays pimcommon qttools
  ];
  propagatedBuildInputs = [ akonadi-calendar kidentitymanagement kmime ];
  outputs = [ "out" "dev" ];
}
