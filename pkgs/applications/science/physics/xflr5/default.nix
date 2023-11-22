{ mkDerivation, lib, fetchzip, qmake }:

mkDerivation rec {
  pname = "xflr5";
  version = "6.61";
  src = fetchzip {
    url = "https://sourceforge.net/code-snapshots/svn/x/xf/xflr5/code/xflr5-code-r1481-tags-v6.61-xflr5.zip";
    sha256 = "sha256-voWnXiBo7+kBPiZLVpSiXyBsYJv/Phd3noA81SQ5Vtw=";
  };

  nativeBuildInputs = [ qmake ];

  meta = with lib; {
    description = "An analysis tool for airfoils, wings and planes";
    homepage = "https://sourceforge.net/projects/xflr5/";
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
  };
}
