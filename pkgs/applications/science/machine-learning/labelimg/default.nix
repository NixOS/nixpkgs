{ stdenv, python2Packages, fetchurl }:
  python2Packages.buildPythonApplication rec {
    pname = "labelImg";
    version = "1.8.1";
    src = fetchurl {
      url = "https://github.com/tzutalin/labelImg/archive/v${version}.tar.gz";
      sha256 = "1banpkpbrny1jx3zsgs544xai62z5yvislbq782a5r47gv2f2k4a";
    };
    nativeBuildInputs = with python2Packages; [
      pyqt4
    ];
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
