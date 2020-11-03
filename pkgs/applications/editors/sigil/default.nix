{ stdenv, mkDerivation, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, boost, xercesc, hunspell, zlib, pcre16
, qtbase, qttools, qtwebengine, qtxmlpatterns
, python3Packages
}:

mkDerivation rec {
  pname = "sigil";
  version = "1.3.0";

  src = fetchFromGitHub {
    repo = "Sigil";
    owner = "Sigil-Ebook";
    rev = version;
    sha256 = "02bkyi9xpaxdcivm075y3praxgvfay9z0189gvr6g8yc3ml1miyr";
  };

  requiredPythonModules = with python3Packages; [ lxml ];

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs = [
    boost xercesc qtbase qttools qtwebengine qtxmlpatterns
    python3Packages.lxml
  ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapProgram "$out/bin/sigil" \
       --prefix PYTHONPATH : $PYTHONPATH \
       ''${qtWrapperArgs[@]}
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = "https://github.com/Sigil-Ebook/Sigil/";
    license = licenses.gpl3;
    # currently unmaintained
    platforms = platforms.linux;
  };
}
