{
  kdeApp, lib,
  extra-cmake-modules,
  kio
}:

kdeApp {
  name = "kdegraphics-mobipocket";
  meta = {
    license = [ lib.licenses.gpl2Plus ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kio ];
}
