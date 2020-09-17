{ mkDerivation, lib, extra-cmake-modules, kdoctools, kparts }:

mkDerivation {
  name = "svgpart";
  meta = with lib; {
    homepage = "https://github.com/KDE/svgpart";
    description = "SVGPart compoenent";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kparts
  ];
}
