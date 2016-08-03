{ stdenv, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, boost, xercesc
, qtbase, qttools, qtwebkit, qtxmlpatterns
, python3, python3Packages
}:

stdenv.mkDerivation rec {
  name = "sigil-${version}";
  version = "0.9.6";

  src = fetchFromGitHub {
    sha256 = "0hihd5f3avpdvxwp5j80qdg74zbw7p20y6j9q8cw7wd0bak58h9c";
    rev = version;
    repo = "Sigil";
    owner = "Sigil-Ebook";
  };

  pythonPath = with python3Packages; [ lxml ];

  propagatedBuildInputs = with python3Packages; [ lxml ];

  buildInputs = [
    cmake pkgconfig
    boost xercesc qtbase qttools qtwebkit qtxmlpatterns
    python3 python3Packages.lxml makeWrapper
  ];

  preFixup = ''
    wrapProgram "$out/bin/sigil" \
       --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath ${python3Packages.lxml})
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = https://github.com/Sigil-Ebook/Sigil/;
    license = stdenv.lib.licenses.gpl3;
    inherit version;
    maintainers = with stdenv.lib.maintainers; [ ramkromberg ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
