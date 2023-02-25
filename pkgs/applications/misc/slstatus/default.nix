{ lib
, stdenv
, fetchgit
, pkg-config
, writeText
, libX11
, libXau
, libXdmcp
, conf ? null
, patches ? []
}:

stdenv.mkDerivation rec {
  pname = "slstatus";
  version = "unstable-2019-02-16";

  src = fetchgit {
    url = "https://git.suckless.org/slstatus";
    rev = "b14e039639ed28005fbb8bddeb5b5fa0c93475ac";
    sha256 = "0kayyhpmppybhwndxgabw48wsk9v8x9xdb05xrly9szkw3jbvgw4";
  };

  configFile = lib.optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = lib.optionalString (conf!=null) "cp ${configFile} config.def.h" + ''
    makeFlagsArray+=(LDLIBS="-lX11 -lxcb -lXau -lXdmcp" CC=$CC)
  '';

  inherit patches;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libX11 libXau libXdmcp];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://tools.suckless.org/slstatus/";
    description = "status monitor for window managers that use WM_NAME like dwm";
    license = licenses.isc;
    maintainers = with maintainers; [ oxzi ];
    platforms = platforms.linux;
  };
}
