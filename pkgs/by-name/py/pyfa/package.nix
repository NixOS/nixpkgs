{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "pyfa";
  version = "2.59.2";
  src = fetchurl {
    url = "https://github.com/pyfa-org/Pyfa/releases/download/v${version}/pyfa-v${version}-linux.AppImage";
    name = "pyfa-${version}";
    sha256 = "sha256-XCLW5K6CoYZwvBXmet5rzNGL9IXdL20RUiv7G1PsqnI=";
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
