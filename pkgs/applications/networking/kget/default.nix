{
  mkDerivation, lib, fetchFromGitHub,
  extra-cmake-modules, kdoctools, makeWrapper,
  kdelibs4support, libgcrypt, libktorrent, qca-qt5, qgpgme,
  kcmutils, kcompletion, kcoreaddons, knotifyconfig, kparts, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui
}:

let
  pname = "kget";
  version = "20170903";

in mkDerivation {
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = pname;
    rev    = "739c0b399faf5a393c7436c0771662596b840fdc";
    sha256 = "0rn6a4xd9zmf9sdjd5b4rh8yky6qm6ffjgjpn4snkdjsn6vm6y43";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];

  buildInputs = [
    kdelibs4support libgcrypt libktorrent qca-qt5 qgpgme
    kcmutils kcompletion kcoreaddons knotifyconfig kparts kwallet kwidgetsaddons kwindowsystem kxmlgui
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
