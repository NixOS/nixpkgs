{ mkDerivation
, fetchurl
, fetchpatch
, lib
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, kconfig
, kinit
, kjsembed
, taglib
, exiv2
, podofo
, kcrash
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

  patches = [
    # https://invent.kde.org/utilities/krename/-/merge_requests/20
    (fetchpatch {
      name = "podofo-0.10-compat.part-1.patch";
      url = "https://invent.kde.org/utilities/krename/-/commit/c0fa9edaad597271ffc34da1f45fa539e3ff5ef5.patch";
      sha256 = "sha256-4kNCUnw3AUK/wfkYRdAnmIWaeZeSag/+1XMjpzWuDaY=";
    })
    (fetchpatch {
      name = "podofo-0.10-compat.part-2.patch";
      url = "https://invent.kde.org/utilities/krename/-/commit/0eb28403821a79d8aa3ac346067ad6ebb2fe06c1.patch";
      sha256 = "sha256-9r9NKqM0cH0EFLbaE3WW4SfjI49n5wxY309HQ07Nuoo=";
    })
  ];

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
