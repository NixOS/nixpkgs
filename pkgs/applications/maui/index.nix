{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  karchive,
  kcoreaddons,
  ki18n,
  kio,
  kirigami2,
  mauikit,
  mauikit-filebrowsing,
  qtmultimedia,
  qtquickcontrols2,
}:

mkDerivation {
  pname = "index-fm";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "-Werror" ""
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    karchive
    kcoreaddons
    ki18n
    kio
    kirigami2
    mauikit
    mauikit-filebrowsing
    qtmultimedia
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Multi-platform file manager";
    mainProgram = "index";
    homepage = "https://invent.kde.org/maui/index-fm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
