{ appimageTools, fetchurl }:

let
  pname = "krunker";
  version = "2.1.3";

  appId = "io.krunker.desktop";

  src = fetchurl {
    url = "https://client2.krunker.io/Official%20Krunker.io%20Client-${version}.AppImage";
    hash = "sha512-a8E5heLsKXOtv/wRKlrnV0GD48cY1mOiSSDW93c7YZ+HoeuBQDxtRaHKg5EqU51Yi+d4tPF5nOh10jZW36c7WQ==";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/{applications,pixmaps}
    install -Dm644 ${appimageContents}/${appId}.desktop -t $out/share/applications
    install -Dm644 ${appimageContents}/${appId}.png -t $out/share/pixmaps

    substituteInPlace $out/share/applications/${appId}.desktop \
      --replace-fail 'Exec=AppRun' "Exec=$pname"
  '';
}
