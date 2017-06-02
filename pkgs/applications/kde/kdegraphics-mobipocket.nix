{
  mkDerivation, lib,
  extra-cmake-modules,
  kio
}:

mkDerivation {
  name = "kdegraphics-mobipocket";
  meta = {
    license = [ lib.licenses.gpl2Plus ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kio ];
}
