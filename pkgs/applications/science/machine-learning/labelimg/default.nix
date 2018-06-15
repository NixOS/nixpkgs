{ stdenv, python2Packages, fetchurl }:
  python2Packages.buildPythonApplication rec {
    name = "labelImg-${version}";
    version = "1.6.0";
    src = fetchurl {
      url = "https://github.com/tzutalin/labelImg/archive/v${version}.tar.gz";
      sha256 = "126kc4r7xm9170kh7snqsfkkc868m5bcnswrv7b4cq9ivlrdwbm4";
    };
    propagatedBuildInputs = with python2Packages; [
      pyqt4
      lxml
    ];
    preBuild = ''
      make qt4py2
    '';
    meta = with stdenv.lib; {
      description = "LabelImg is a graphical image annotation tool and label object bounding boxes in images";
      homepage = https://github.com/tzutalin/labelImg;
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [ maintainers.cmcdragonkai ];
    };
  }
