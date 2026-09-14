{
  lib,
  stdenv,
  cmake,
  kdePackages,
  recoll,
  xapian,
}:

stdenv.mkDerivation {
  pname = "recoll-kio";
  version = recoll.version;

  src = recoll.src;

  strictDeps = true;
  buildInputs = [
    kdePackages.kio
    recoll
    xapian
  ];

  postPatch = ''
    cp ./kde/kioslave/kio_recoll/CMakeLists-KF6.txt ./kde/kioslave/kio_recoll/CMakeLists.txt
  '';

  dontWrapQtApps = true;

  nativeBuildInputs = [ cmake ];

  cmakeDir = "../kde/kioslave/kio_recoll";

  __structuredAttrs = true;
  meta = {
    homepage = recoll.meta.homepage;
    description = "Plasma KIO worker for recoll";
    license = recoll.meta.license;
    maintainers = with lib.maintainers; [ numkem ];
    platforms = lib.platforms.linux;
  };
}
