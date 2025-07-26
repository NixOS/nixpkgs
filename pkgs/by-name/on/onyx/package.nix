{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "onyx";
  version = "20240928";
  src = fetchurl {
    url = "https://github.com/mtolly/onyx/releases/download/${version}/${pname}-${version}-linux-x64.AppImage";
    hash = "sha256-tK3Npd92L4SkfAc+eyyhkfiKWvNQcMVlNSSgE/jG6Uo=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Convert songs between Clone Hero, Rock Band, and Guitar Hero";
    homepage = "https://github.com/mtolly/onyx";
    changelog = "https://github.com/mtolly/onyx/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ appsforartists ];
    platforms = [ "x86_64-linux" ];
  };
}
