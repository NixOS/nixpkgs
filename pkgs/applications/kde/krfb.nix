{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kdelibs4support, kdnssd, libvncserver, libXtst
}:

mkDerivation {
  name = "krfb";
  meta = {
    license = with lib.licenses; [ gpl2 fdl12 ];
    maintainers = with lib.maintainers; [ jerith666 ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ libvncserver libXtst ];
  propagatedBuildInputs = [ kdelibs4support kdnssd ];
}
