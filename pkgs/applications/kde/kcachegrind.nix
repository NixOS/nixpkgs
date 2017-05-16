{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kio, ki18n,
  perl, python, php
}:

mkDerivation {
  name = "kcachegrind";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ orivej ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];
  propagatedBuildInputs = [ kio ];
  buildInputs = [ perl python php ki18n ];
  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ perl php python]}")
  '';
}
