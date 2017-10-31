{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  karchive, kconfig, kcrash, kguiaddons, kinit, kparts, kwindowsystem
}:

let
  pname = "krusader";
  version = "2.6.0";
in mkDerivation rec {
  name = "krusader-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${name}.tar.xz";
    sha256 = "0f9skfvp0hdml8qq6v22z9293ndijd8kwbpdj7wpvgd6mlya8qbh";
  };

  meta = with lib; {
    description = "Norton/Total Commander clone for KDE";
    license = licenses.gpl2;
    homepage = http://www.krusader.org;
    maintainers = with maintainers; [ sander ];
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [ karchive kconfig kcrash kguiaddons kinit kparts kwindowsystem ];
}
