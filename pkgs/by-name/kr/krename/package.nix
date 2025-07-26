{
  stdenv,
  fetchurl,
  fetchpatch,
  lib,
  extra-cmake-modules,
  libsForQt5,
  taglib,
  exiv2,
  podofo_0_10,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "krename";
  version = "5.0.2";

  src = fetchurl {
    url = "mirror://kde/stable/${finalAttrs.pname}/${finalAttrs.version}/src/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-sjxgp93Z9ttN1/VaxV/MqKVY+miq+PpcuJ4er2kvI+0=";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-with-exiv2-0.28.patch";
      url = "https://invent.kde.org/utilities/krename/-/commit/e7dd767a9a1068ee1fe1502c4d619b57d3b12add.patch";
      hash = "sha256-JpLVbegRHJbXi/Z99nZt9kgNTetBi+L9GfKv5s3LAZw=";
    })
    (fetchpatch {
      name = "add-support-for-podofo-0.10.patch";
      url = "https://invent.kde.org/utilities/krename/-/commit/056d614dc2166cd25749caf264b1b4d9d348f4d4.patch";
      hash = "sha256-OYjd1QJWIdWBWVlYzmcn7DTpeoToZKjVfVQpFNZX02E=";
    })
  ];

  buildInputs = [
    taglib
    exiv2
    podofo_0_10
  ];

  nativeBuildInputs = with libsForQt5; [
    extra-cmake-modules
    # begin qt libs
    kdoctools
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with libsForQt5; [
    # begin qt libs
    kconfig
    kcrash
    qtbase
    kjsembed
    kio
  ];

  NIX_LDFLAGS = "-ltag";

  meta = {
    description = "Powerful batch renamer for KDE";
    mainProgram = "krename";
    homepage = "https://kde.org/applications/utilities/krename/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      peterhoeg
      kuflierl
    ];
    inherit (libsForQt5.kconfig.meta) platforms;
  };
})
