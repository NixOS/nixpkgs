{
  fetchurl,
  appimageTools,
  lib,
}:
let
  pname = "pyfa";
  version = "2.58.2";

  src = fetchurl {
    url = "https://github.com/pyfa-org/Pyfa/releases/download/v${version}/${pname}-v${version}-linux.AppImage";
    hash = "sha256-CSCKfNHuTfSfTibZFNbvyD3IUTJPm8pGqITD7peSrA8=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: [ pkgs.libnotify ];
  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -m 444 -D ${contents}/pyfa.desktop -t $out/share/applications

      substituteInPlace $out/share/applications/pyfa.desktop \
        --replace "Exec=usr/bin/python3.11" "Exec=${pname}"

      cp -r ${contents}/usr/share/* $out/share
    '';

  meta = with lib; {
    description = "Python fitting assistant, cross-platform fitting tool for EVE Online";
    homepage = "https://github.com/pyfa-org/Pyfa";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sheemap ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "pyfa";
  };
}
