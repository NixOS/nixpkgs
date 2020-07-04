{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  karchive, kconfig, kcrash, kguiaddons, kinit, kparts, kwindowsystem
}:

let
  pname = "krusader";
  version = "2.7.2";
in mkDerivation rec {
  pname = "krusader";
  inherit version;

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "02b1jz5a7cjr13v6c7fczrhs1xmg1krnva5fxk8x2bf4nd1rm8s1";
  };

  meta = with lib; {
    description = "Norton/Total Commander clone for KDE";
    license = licenses.gpl2;
    homepage = "http://www.krusader.org";
    maintainers = with maintainers; [ sander turion ];
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [ karchive kconfig kcrash kguiaddons kinit kparts kwindowsystem ];
}
