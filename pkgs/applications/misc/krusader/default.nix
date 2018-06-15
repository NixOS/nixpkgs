{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  karchive, kconfig, kcrash, kguiaddons, kinit, kparts, kwindowsystem
}:

let
  pname = "krusader";
  version = "2.7.0";
in mkDerivation rec {
  name = "krusader-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${name}.tar.xz";
    sha256 = "09ws3samxnjk0qi9pcfm2rmw0nr5mzn9pzpljgrdb5qj7cmm4hcb";
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
