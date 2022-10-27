{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, akonadi-contacts, akonadi-search, kcmutils, kcodecs, kcompletion,
  kconfigwidgets, kcontacts, ki18n, kiconthemes, kio, kitemviews, kjobwidgets,
  kldap, kwallet,
}:

mkDerivation {
  pname = "libkdepim";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi akonadi-contacts akonadi-search kcmutils kcodecs kcompletion
    kconfigwidgets kcontacts ki18n kiconthemes kio kitemviews kjobwidgets kldap
    kwallet
  ];
}
