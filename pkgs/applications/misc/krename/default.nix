{
  mkDerivation,
  fetchurl,
  fetchpatch,
  lib,
  extra-cmake-modules,
  kdoctools,
  wrapGAppsHook3,
  kconfig,
  kinit,
  kjsembed,
  taglib,
  exiv2,
  podofo,
  kcrash,
}:

let
  pname = "krename";
  version = "5.0.2";

in
mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "sha256-sjxgp93Z9ttN1/VaxV/MqKVY+miq+PpcuJ4er2kvI+0=";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-with-exiv2-0.28.patch";
      url = "https://invent.kde.org/utilities/krename/-/commit/e7dd767a9a1068ee1fe1502c4d619b57d3b12add.patch";
      hash = "sha256-JpLVbegRHJbXi/Z99nZt9kgNTetBi+L9GfKv5s3LAZw=";
    })
  ];

  buildInputs = [
    taglib
    exiv2
    podofo
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    kconfig
    kcrash
    kinit
    kjsembed
  ];

  NIX_LDFLAGS = "-ltag";

  meta = with lib; {
    description = "Powerful batch renamer for KDE";
    mainProgram = "krename";
    homepage = "https://kde.org/applications/utilities/krename/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kconfig.meta) platforms;
  };
}
