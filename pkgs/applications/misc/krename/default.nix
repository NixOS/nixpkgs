{
  kdeDerivation, kdeWrapper, fetchFromGitHub, lib,
  extra-cmake-modules, kdoctools, kconfig, kinit, kjsembed,
  taglib, exiv2, podofo
}:

let
  pname = "krename";
  version = "20161228";
  unwrapped = kdeDerivation rec {
    name = "${pname}-${version}";

    src = fetchFromGitHub {
      owner  = "KDE";
      repo   = "krename";
      rev    = "4e55c2bef50898eb4a6485ce068379b166121895";
      sha256 = "09yz3sxy2l6radfybkj2f7224ggf315vnvyksk0aq8f03gan6cbp";
    };

    meta = with lib; {
      homepage = http://www.krename.net;
      description = "A powerful batch renamer for KDE";
      inherit (kconfig.meta) platforms;
      maintainers = with maintainers; [ urkud peterhoeg ];
    };

    buildInputs = [ taglib exiv2 podofo ];
    nativeBuildInputs = [ extra-cmake-modules kdoctools ];
    propagatedBuildInputs = [ kconfig kinit kjsembed ];
  };

in kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/krename" ];
}
