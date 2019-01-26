{ stdenv, fetchurl, qmake, qtbase, qtwebkit }:

stdenv.mkDerivation rec {
  name = "mindforger-${version}";
  version = "1.48.2";

  src = fetchurl {
    url = "https://github.com/dvorka/mindforger/releases/download/1.48.0/mindforger_${version}.tgz";
    sha256 = "1wlrl8hpjcpnq098l3n2d1gbhbjylaj4z366zvssqvmafr72iyw4";
  };

  nativeBuildInputs = [ qmake ] ;
  buildInputs = [ qtbase qtwebkit ] ;

  doCheck = true;

  enableParallelBuilding = true ;

  patches = [ ./build.patch ] ;

  postPatch = ''
    substituteInPlace deps/discount/version.c.in --subst-var-by TABSTOP 4
    substituteInPlace app/resources/gnome-shell/mindforger.desktop --replace /usr "$out"
  '';

  preConfigure = ''
    export AC_PATH="$PATH"
    pushd deps/discount
    ./configure.sh
    popd
  '';

  qmakeFlags = [ "-r mindforger.pro" "CONFIG+=mfnoccache" ] ;

  meta = with stdenv.lib; {
    description = "Thinking Notebook & Markdown IDE";
    longDescription = ''
     MindForger is actually more than an editor or IDE - it's human
     mind inspired personal knowledge management tool
    '';
    homepage = https://www.mindforger.com;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
