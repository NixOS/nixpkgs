{ stdenv, fetchgit, pkgconfig, writeText, libX11, conf ? null, patches ? [] }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "slstatus";
  version = "unstable-2019-02-16";

  src = fetchgit {
    url = "https://git.suckless.org/slstatus";
    rev = "b14e039639ed28005fbb8bddeb5b5fa0c93475ac";
    sha256 = "0kayyhpmppybhwndxgabw48wsk9v8x9xdb05xrly9szkw3jbvgw4";
  };

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  inherit patches;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://tools.suckless.org/slstatus/";
    description = "status monitor for window managers that use WM_NAME like dwm";
    license = licenses.isc;
    maintainers = with maintainers; [ geistesk ];
    platforms = platforms.linux;
  };
}
