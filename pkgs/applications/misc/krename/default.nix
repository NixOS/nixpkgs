{
  mkDerivation, fetchFromGitHub, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kconfig, kinit, kjsembed, taglib, exiv2, podofo,
  kcrash
}:

let
  pname = "krename";
  version = "20170610";
in mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "krename";
    rev    = "18000edfec52de0b417d575e14eb078b4bd7b2f3";
    sha256 = "0hsrlfrbi42jqqnkcz682c6yrfi3xpl299672knj22074wr6sv0j";
  };

  meta = with lib; {
    homepage = http://www.krename.net;
    description = "A powerful batch renamer for KDE";
    inherit (kconfig.meta) platforms;
    maintainers = with maintainers; [ peterhoeg ];
  };

  buildInputs = [ taglib exiv2 podofo ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [ kconfig kcrash kinit kjsembed ];
}
