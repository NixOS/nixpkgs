{ mkDerivation, lib, qmake, fetchsvn }:

mkDerivation rec {
  pname = "xflr5";
  version = "6.61";

  sourceRoot = "${src.name}/xflr5";
  src = fetchsvn {
    url = "https://svn.code.sf.net/p/xflr5/code/trunk";
    rev = "1480";
    sha256 = "sha256-Uj6R15OT5i5tAJEYWqyFyN5Z51Wz5RjO26mWC3Y6QAI=";
  };

  nativeBuildInputs = [ qmake ];

  meta = with lib; {
    description = "An analysis tool for airfoils, wings and planes";
    mainProgram = "xflr5";
    homepage = "https://sourceforge.net/projects/xflr5/";
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
  };
}
