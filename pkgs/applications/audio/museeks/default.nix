{ lib, fetchurl, appimageTools }:

let
  pname = "museeks";
  version = "0.13.1";

  src = fetchurl {
    url = "https://github.com/martpie/museeks/releases/download/${version}/museeks-x86_64.AppImage";
    hash = "sha256-LvunhCFmpv00TnXzWjp3kQUAhoKpmp6pqKgcaUqZV+o=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A simple, clean and cross-platform music player";
    homepage = "https://github.com/martpie/museeks";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
