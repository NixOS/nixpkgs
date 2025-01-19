{
  mkDerivation,
  extra-cmake-modules,
  ki18n,
  kxmlgui,
  kcodecs,
  kio,
}:

mkDerivation {
  pname = "libkomparediff2";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kcodecs
    ki18n
    kxmlgui
    kio
  ];
}
