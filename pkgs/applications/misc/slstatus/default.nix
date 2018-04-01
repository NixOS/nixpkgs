{ stdenv, fetchgit, pkgconfig, writeText, libX11, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "slstatus-${version}";
  version = "unstable-2018-03-28";

  src = fetchgit {
    url = https://git.suckless.org/slstatus;
    rev = "faa52bdcc0221de2d8fae950e409a8ac5e05bfcd";
    sha256 = "0i8k7gjvx51y0mwxjlqhyk2dpvkb2d3y8x4l6ckdnyiy5632pn76";
  };

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = https://tools.suckless.org/slstatus/;
    description = "status monitor for window managers that use WM_NAME like dwm";
    license = licenses.isc;
    maintainers = with maintainers; [ geistesk ];
    platforms = platforms.linux;
  };
}
