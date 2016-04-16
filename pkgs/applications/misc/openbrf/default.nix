{ stdenv, fetchFromGitHub, qt4, qmake4Hook, vcg, glew }:

stdenv.mkDerivation {
  name = "openbrf-2016-01-09";

  src = fetchFromGitHub {
    owner = "cfcohen";
    repo = "openbrf";
    rev = "c18d7431e1d499cee11586f4a035fb5fdc0d3330";
    sha256 = "0laikpz0ljz7l5fgapwj09ygizmvj1iywnpfgfd0i14j46s134xb";
  };

  buildInputs = [ qt4 qmake4Hook vcg glew ];

  enableParallelBuilding = true;

  qmakeFlags = [ "openBrf.pro" ];

  postPatch = ''
    sed -i 's,^VCGLIB .*,VCGLIB = ${vcg}/include,' openBrf.pro
  '';

  installPhase = ''
    install -Dm755 openBrf $out/bin/openBrf
  '';

  meta = with stdenv.lib; {
    description = "A tool to edit resource files (BRF)";
    homepage = https://github.com/cfcohen/openbrf;
    maintainers = with stdenv.lib.maintainers; [ abbradar ];
    license = licenses.free;
    platforms = platforms.linux;
  };
}
