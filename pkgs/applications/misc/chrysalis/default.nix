{ lib, appimageTools, fetchurl }:

let
  pname = "chrysalis";
  version = "0.7.9";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}-binary";

  src = fetchurl {
    url = "https://github.com/keyboardio/${pname}/releases/download/${pname}-${version}/${pname}-${version}.AppImage";
    sha256 = "12w4vv7dwfpvxpc8kpfas90y7yy8mb8dj2096z3vw1bli5lrn3zi";
  };

  multiPkgs = null;
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [
    p.glib
  ];

  extraInstallCommands = "mv $out/bin/${name} $out/bin/${pname}";

  meta = with lib; {
    description = "A graphical configurator for Kaleidoscope-powered keyboards";
    homepage = "https://github.com/keyboardio/Chrysalis";
    license = licenses.gpl3;
    maintainers = with maintainers; [ aw ];
    platforms = [ "x86_64-linux" ];
  };
}
