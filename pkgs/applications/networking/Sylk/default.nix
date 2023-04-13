{ appimageTools, fetchurl, lib }:

let
  pname = "Sylk";
  version = "3.0.1";
in

appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://download.ag-projects.com/Sylk/Sylk-${version}-x86_64.AppImage";
    hash = "sha256-VgepO7LHFmNKq/H0RFcIkafgtiVGt8K/LdiCO5Dw2s4=";
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "Sylk WebRTC client";
    homepage = "https://sylkserver.com/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ zimbatm ];
    platforms = [ "i386-linux" "x86_64-linux" ];
  };
}
