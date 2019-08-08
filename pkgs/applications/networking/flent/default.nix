{ stdenv, buildPythonApplication, fetchPypi, matplotlib, procps, pyqt5, qt5
, sphinx }:

buildPythonApplication rec {
  pname = "flent";
  version = "1.2.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0ziblk36rzr99pbi7xzzkci3sr41m0jf72v38ynp63df6szbbfjb";
  };

  buildInputs = [ sphinx ];
  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  checkInputs = [ procps ];

  propagatedBuildInputs = [ matplotlib procps pyqt5 ];

  postInstall = ''
    for program in $out/bin/*; do
      wrapQtApp $program --prefix PYTHONPATH : $PYTHONPATH
    done
  '';

  meta = with stdenv.lib; {
    description = "The FLExible Network Tester";
    homepage = "https://flent.org";
    license = licenses.gpl3;

    maintainers = [ maintainers.mmlb ];
  };
}
