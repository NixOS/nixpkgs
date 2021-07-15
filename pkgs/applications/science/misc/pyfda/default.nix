{ lib, python3Packages, wrapQtAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "pyfda";
  version = "0.2.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "11whn2hhr0szbzpmly2p47prvsm2rhizf60iz3pfgkbrnrjs7mhv";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];
  propagatedBuildInputs = with python3Packages; [ numpy scipy matplotlib pyqt5 docutils nmigen ];

  patches = [ ./nmigen.diff ];
  postPatch = ''
    # The pyfdax_no_term command does not make sense on Linux.
    substituteInPlace setup.py \
      --replace "'pyfdax_no_term = pyfda.pyfdax:main'," ""

    # This code is unused but causes problems with Py3.7 due to the async keyword.
    rm pyfda/fixpoint_widgets/iir_df1.py

    # Those tests attempt to use Qt and fail in nix-build.
    rm -rf pyfda/tests/widgets
  '';

  preCheck = ''
    export HOME=`mktemp -d`
  '';

  postInstall = ''
    wrapQtApp "$out"/bin/pyfdax
  '';

  meta = with lib; {
    description = "Python filter design analysis tool";
    homepage = "https://github.com/chipmuenk/pyfda";
    license = licenses.mit;
    maintainers = [ maintainers.sb0 ];
  };
}
