{ lib, appimageTools, fetchurl, gtk3, gsettings-desktop-schemas }:

let
  pname = "chrysalis";
  version = "0.8.4";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}-binary";

  src = fetchurl {
    url = "https://github.com/keyboardio/${pname}/releases/download/v${version}/${pname}-${version}.AppImage";
    sha256 = "b41f3e23dac855b1588cff141e3d317f96baff929a0543c79fccee0c6f095bc7";
  };

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

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
