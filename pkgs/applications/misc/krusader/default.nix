{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  karchive, kconfig, kcrash, kguiaddons, kinit, kparts, kwindowsystem
}:

let
  pname = "krusader";
  version = "2.7.1";
in mkDerivation rec {
  name = "krusader-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${name}.tar.xz";
    sha256 = "1svxj1qygyr3a4dkx0nh2d6r4q7pfj00brzghl94mf4q0rz4vhfm";
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
