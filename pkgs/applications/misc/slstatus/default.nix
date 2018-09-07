{ stdenv, fetchgit, pkgconfig, writeText, libX11, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "slstatus-${version}";
  version = "unstable-2018-04-16";

  src = fetchgit {
    url = https://git.suckless.org/slstatus;
    rev = "97ef7c2a1d67bb2c9c379e657fbc8e35acd6aafb";
    sha256 = "1777hgl10imk0l2sgnqgbkfchv1mpxrd82ninzwp7f1rgwchz36v";
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
