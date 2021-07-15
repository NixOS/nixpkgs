{
  mkDerivation, lib,
  extra-cmake-modules,
}:

mkDerivation {
  pname = "kpublictransport";
  meta = {
    license = [ lib.licenses.cc0 ];
    maintainers = [ lib.maintainers.samueldr ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
}
