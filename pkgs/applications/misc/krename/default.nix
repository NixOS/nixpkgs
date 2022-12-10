{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kconfig, kinit, kjsembed, taglib, exiv2, podofo,
  kcrash
}:

let
  pname = "krename";
  version = "5.0.2";

in mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "sha256-sjxgp93Z9ttN1/VaxV/MqKVY+miq+PpcuJ4er2kvI+0=";
  };

  buildInputs = [ taglib exiv2 podofo ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kjsembed ];

  NIX_LDFLAGS = "-ltag";

  meta = with lib; {
    description = "A powerful batch renamer for KDE";
    homepage = "https://kde.org/applications/utilities/krename/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kconfig.meta) platforms;
  };
}
