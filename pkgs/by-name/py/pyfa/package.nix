{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "pyfa";
  version = "v2.58.3";
  src = fetchurl {
    url = "https://github.com/pyfa-org/Pyfa/releases/download/${version}/pyfa-${version}-linux.AppImage";
    name = "pyfa-${version}";
    sha256 = "opzZSiVWfJv//KONocL9byZKqX/hWkPU+ssdceUDXh0=";
  };
  appimageContents = appimageTools.extractType1 { inherit pname version src; };
in
appimageTools.wrapType1 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/pyfa.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/pyfa.desktop \
      --replace-warn 'Exec=pyfa' 'Exec=${pname}'

    cp -r ${appimageContents}/pyfa.png $out/share
  '';

  meta = with lib; {
    description = "Python fitting assistant, cross-platform fitting tool for EVE Online";
    homepage = "https://github.com/pyfa-org/Pyfa";
    license = licenses.gpl3;
    mainProgram = "pyfa";
  };
}
