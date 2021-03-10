{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, breeze-icons
, karchive
, kcoreaddons
, ki18n
, kio
, kirigami2
, mauikit
, qtmultimedia
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "index";
  version = "1.2.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "index-fm";
    rev = "v${version}";
    sha256 = "1v6z44c88cqgr3b758yq6l5d2zj1vhlnaq7v8rrhs7s5dsimzlx8";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    breeze-icons
    karchive
    kcoreaddons
    ki18n
    kio
    kirigami2
    mauikit
    qtmultimedia
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Multi-platform file manager";
    homepage = "https://invent.kde.org/maui/index-fm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
