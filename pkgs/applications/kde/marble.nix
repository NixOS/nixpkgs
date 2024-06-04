{ mkDerivation, lib
, extra-cmake-modules, kdoctools
, qtscript, qtsvg, qtquickcontrols, qtwebengine
, krunner, shared-mime-info, kparts, knewstuff
, gpsd, perl, protobuf_21
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
    protobuf_21 qtscript qtsvg qtquickcontrols qtwebengine shared-mime-info krunner kparts
    knewstuff gpsd
  ];
  preConfigure = ''
    cmakeFlags+=" -DINCLUDE_INSTALL_DIR=''${!outputDev}/include"
  '';
}
