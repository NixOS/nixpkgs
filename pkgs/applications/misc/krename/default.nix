{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kconfig, kinit, kjsembed, taglib, exiv2, podofo,
  kcrash
}:

let
  pname = "krename";
  version = "5.0.0";

in mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "136j1dkqrhv458rjh5v3vzjhvq6dhz7k79zk6mmx8zvqacc7cq8a";
  };

  buildInputs = [ taglib exiv2 podofo ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kjsembed ];

  meta = with lib; {
    description = "A powerful batch renamer for KDE";
    homepage = "https://kde.org/applications/utilities/krename/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kconfig.meta) platforms;
  };
}
