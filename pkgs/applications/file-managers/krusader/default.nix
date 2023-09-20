{ mkDerivation
, lib
, fetchurl
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, karchive
, kconfig
, kcrash
, kguiaddons
, kinit
, kparts
, kwindowsystem
}:

mkDerivation rec {
  pname = "krusader";
  version = "2.7.2";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-QaOaQ7PELdHR7K6obfMMr/agYf7MHWb2CFmyo8qXYQk=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    karchive
    kconfig
    kcrash
    kguiaddons
    kinit
    kparts
    kwindowsystem
  ];

  meta = with lib; {
    homepage = "http://www.krusader.org";
    description = "Norton/Total Commander clone for KDE";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sander ];
    mainProgram = "krusader";
  };
}
