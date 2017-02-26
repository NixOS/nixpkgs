{ kdeApp, lib, extra-cmake-modules, ki18n, kxmlgui, kcodecs, kio }:

kdeApp {
  name = "libkomparediff2";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcodecs ki18n kxmlgui kio ];
}
