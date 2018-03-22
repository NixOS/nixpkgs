{ mkDerivation, fetchFromGitHub, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook
, qtmultimedia, qtquickcontrols2, qtwebsockets
, kconfig, kcmutils, kcrash, kdeclarative, kfilemetadata, kinit
, baloo
}:

mkDerivation rec {
  name = "elisa-${version}";
  # 0.1 is expected in early/mid 2018-04
  version = "0.0.20180320";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    rev    = "9dd35d7244a8a3553275152f5b50fbe6d272ce64";
    sha256 = "0mjqvcpk2y4jlwkka8gzl50wgqjjx9bzpbrj79cr0ib3jyviss4k";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [
    qtmultimedia qtquickcontrols2 qtwebsockets
    kconfig kcmutils kcrash kdeclarative kfilemetadata kinit
    baloo
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Elisa Music Player";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kconfig.meta) platforms;
  };
}
