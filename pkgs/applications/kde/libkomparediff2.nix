{ kdeApp, lib, ecm, ki18n, kxmlgui, kcodecs, kio }:

kdeApp {
  name = "libkomparediff2";
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kcodecs ki18n kxmlgui kio ];
}
