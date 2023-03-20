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
  version = "unstable-2022-12-19";

  src = fetchgit {
    url = "https://git.suckless.org/slstatus";
    rev = "c919def84fd4f52f501548e5f7705b9d56dd1459";
    hash = "sha256-nEIHIO8CAYdtX8GniO6GDEaHj7kEu81b05nCMVdr2SE=";
  };

  configFile = lib.optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = ''
    ${lib.optionalString (conf!=null) "cp ${configFile} config.def.h"}
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
