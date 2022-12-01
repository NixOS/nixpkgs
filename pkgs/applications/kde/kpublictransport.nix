{ mkDerivation
, lib
, extra-cmake-modules
}:

mkDerivation {
  pname = "kpublictransport";
  meta = with lib; {
    license = [ licenses.cc0 ];
    maintainers = [ maintainers.samueldr ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
}
