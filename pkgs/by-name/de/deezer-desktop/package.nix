{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "deezer-desktop";
  version = "7.0.120";
  arch = "x86_64";

  src = fetchurl {
    url = "https://github.com/aunetx/deezer-linux/releases/download/v${version}/deezer-desktop-${version}-${arch}.AppImage";
    hash = "sha256-I9ElhNTwW1qIbCb5tq9iTIsnpGs+G5cNxq5XdJ8kEt4=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -m 444 -D ${contents}/deezer-desktop.desktop -t $out/share/applications

      substituteInPlace $out/share/applications/deezer-desktop.desktop \
        --replace "Exec=AppRun" "Exec=${pname}"

      cp -r ${contents}/usr/share/* $out/share
    '';

  meta = {
    description = "Universal linux port of deezer";
    homepage = "https://github.com/aunetx/deezer-linux/";
    downloadPage = "https://github.com/aunetx/deezer-linux/releases";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ afrangio ];
    platforms = lib.platforms.linux;
    mainProgram = "deezer-desktop";
  };
}
