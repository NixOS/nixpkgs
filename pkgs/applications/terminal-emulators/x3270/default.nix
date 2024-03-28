{ lib, stdenv, fetchurl, m4, expat
, libX11, libXt, libXaw, libXmu, bdftopcf, mkfontdir
, fontadobe100dpi, fontadobeutopia100dpi, fontbh100dpi
, fontbhlucidatypewriter100dpi, fontbitstream100dpi
, tcl
, ncurses }:

let
  majorVersion = "4";
  minorVersion = "2";
  versionSuffix = "ga9";
in stdenv.mkDerivation rec {
  pname = "x3270";
  version = "${majorVersion}.${minorVersion}${versionSuffix}";

  src = fetchurl {
    url = "http://x3270.bgp.nu/download/0${majorVersion}.0${minorVersion}/suite3270-${version}-src.tgz";
    sha256 = "01i81lh8xbpz2nbj4hv2yfdh6mpv46jq6nb7b2c3w2pmhcvhq32z";
  };

  buildFlags = [ "unix" ];

  postConfigure = ''
    pushd c3270 ; ./configure ; popd
  '';

  nativeBuildInputs = [ m4 ];
  buildInputs = [
    expat
    libX11 libXt libXaw libXmu bdftopcf mkfontdir
    fontadobe100dpi fontadobeutopia100dpi fontbh100dpi
    fontbhlucidatypewriter100dpi fontbitstream100dpi
    tcl
    ncurses
    expat
  ];

  installTargets = [ "install" "install.man" ];

  meta = with lib; {
    description = "IBM 3270 terminal emulator for the X Window System";
    homepage = "http://x3270.bgp.nu/index.html";
    license = licenses.bsd3;
    maintainers = [ maintainers.anna328p ];
  };
}
