{ mkDerivation, lib
, extra-cmake-modules, kdoctools
, qtscript, qtsvg, qtquickcontrols, qtwebengine
, krunner, shared-mime-info, kparts, knewstuff
, gpsd, perl, fetchpatch
}:

mkDerivation {
  pname = "marble";
  meta = {
    homepage = "https://apps.kde.org/marble/";
    description = "Virtual globe";
    license = with lib.licenses; [ lgpl21 gpl3 ];
  };
  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools perl ];
  propagatedBuildInputs = [
    qtscript qtsvg qtquickcontrols qtwebengine shared-mime-info krunner kparts
    knewstuff gpsd
  ];
  patches = [
    (fetchpatch {
      # Backport fix to allow compilation with gpsd 3.23.1
      # Remove when marble compiles without the patch.
      # See: https://invent.kde.org/education/marble/-/merge_requests/57
      url = "https://invent.kde.org/education/marble/-/commit/8aadc3eb8f9484a65d497d442cd8c61fe1462bef.diff";
      sha256 = "sha256-ZkPXyunVItSRctv6SLGIonvyZwLDhCz+wfJrIXeHcDo=";
    })
  ];
  preConfigure = ''
    cmakeFlags+=" -DINCLUDE_INSTALL_DIR=''${!outputDev}/include"
  '';
}
