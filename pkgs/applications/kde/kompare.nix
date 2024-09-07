{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kiconthemes, kparts, ktexteditor, kwidgetsaddons, libkomparediff2,
}:

mkDerivation {
  pname = "kompare";
  meta = {
    homepage = "https://apps.kde.org/kompare/";
    description = "Diff/patch frontend";
    mainProgram = "kompare";
    license = with lib.licenses; [ gpl2 ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kiconthemes kparts ktexteditor kwidgetsaddons libkomparediff2
  ];
  outputs = [ "out" "dev" ];
}
