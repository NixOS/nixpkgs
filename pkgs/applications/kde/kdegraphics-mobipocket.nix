{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kio,
}:

mkDerivation {
  pname = "kdegraphics-mobipocket";
  meta = with lib; {
    license = [ licenses.gpl2Plus ];
    maintainers = [ maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kio ];
  outputs = [
    "out"
    "dev"
  ];
}
