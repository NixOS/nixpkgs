{stdenv, fetchurl, wxGTK, perl, python, zlib}:
let
  s = # Generated upstream information
  rec {
    baseName="golly";
    version="2.6";
    name="${baseName}-${version}";
    hash="1n1k3yf23ymlwq4k6p4v2g04qd29pg2rabr4l7m9bj2b2j1zkqhz";
    url="mirror://sourceforge/project/golly/golly/golly-2.6/golly-2.6-src.tar.gz";
    sha256="1n1k3yf23ymlwq4k6p4v2g04qd29pg2rabr4l7m9bj2b2j1zkqhz";
  };
  buildInputs = [
    wxGTK perl python zlib
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  preConfigure = ''
    cd gui-wx/configure
  '';
  meta = {
    inherit (s) version;
    description = "Cellular automata simulation program";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    downloadPage = "http://sourceforge.net/projects/golly/files/golly";
  };
}
