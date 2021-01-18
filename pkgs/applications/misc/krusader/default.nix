{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  karchive, kconfig, kcrash, kguiaddons, kinit, kparts, kwindowsystem
}:

mkDerivation rec {
  pname = "krusader";
  version = "2.7.2";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "02b1jz5a7cjr13v6c7fczrhs1xmg1krnva5fxk8x2bf4nd1rm8s1";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ karchive kconfig kcrash kguiaddons kinit kparts kwindowsystem ];

  meta = with lib; {
    description = "Norton/Total Commander clone for KDE";
    homepage = "http://www.krusader.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sander turion ];
  };
}
