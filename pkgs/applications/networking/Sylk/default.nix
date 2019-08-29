{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "Sylk";
  version = "2.1.0";
in

appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://download.ag-projects.com/Sylk/Sylk-${version}-x86_64.AppImage";
    sha256 = "1ifi8qr6f84dcssxhv5ar1s48nsqxiv2j1blc82248hmq5is24mf";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "Sylk WebRTC client";
    homepage = "http://sylkserver.com/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ zimbatm ];
    platforms = [ "i386-linux" "x86_64-linux" ];
  };
}
