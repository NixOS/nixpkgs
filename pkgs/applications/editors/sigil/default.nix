{ stdenv, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, boost, xercesc
, qtbase, qttools, qtwebkit, qtxmlpatterns
, python3, python3Packages
}:

stdenv.mkDerivation rec {
  name = "sigil-${version}";
  version = "0.9.10";

  src = fetchFromGitHub {
    sha256 = "11r7043kbqv67z1aqk929scsg6yllldpl8icl32dw3dai7f1c658";
    rev = version;
    repo = "Sigil";
    owner = "Sigil-Ebook";
  };

  pythonPath = with python3Packages; [ lxml ];

  propagatedBuildInputs = with python3Packages; [ lxml ];

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs = [
    boost xercesc qtbase qttools qtwebkit qtxmlpatterns
    python3 python3Packages.lxml ];

  preFixup = ''
    wrapProgram "$out/bin/sigil" \
       --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath ${python3Packages.lxml})
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = https://github.com/Sigil-Ebook/Sigil/;
    license = licenses.gpl3;
    maintainers =[ maintainers.ramkromberg ];
    platforms = platforms.linux;
  };
}
