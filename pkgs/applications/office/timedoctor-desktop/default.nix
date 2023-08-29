{ appimageTools
, fetchurl
, lib
, makeWrapper
}:

let
  pname = "timedoctor-desktop";
  version = "3.12.16";

  src = fetchurl {
    url = "https://repo2.timedoctor.com/td-desktop-hybrid/prod/v${version}/timedoctor-desktop_${version}_linux-x86_64.AppImage";
    hash = "sha256-EodbUs88REwa3JMy2/reHcxLwvNaPtVKZDIkLPd11BU=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    install -Dm444 ${appimageContents}/timedoctor-desktop.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/timedoctor-desktop.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/timedoctor-desktop.desktop \
      --replace 'Exec=AppRun' 'Exec=timedoctor-desktop'
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram "$out/bin/timedoctor-desktop" \
      --add-flags "--disable-gpu-sandbox"
  '';

  extraPkgs = _: with _; [
    (libjpeg.override { enableJpeg8 = true; })
  ];

  meta = with lib; {
    description = "Employee time tracking software (Time Doctor Classic)";
    homepage = "https://www.timedoctor.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ surfaceflinger ];
  };
}
