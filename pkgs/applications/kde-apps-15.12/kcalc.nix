{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, kconfig
, kconfigwidgets
, kguiaddons
, kinit
, knotifications

}:

kdeApp {
  name = "kcalc";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    kconfig
    kconfigwidgets
    kguiaddons
    kinit
    knotifications
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/kcalc"
  '';

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
