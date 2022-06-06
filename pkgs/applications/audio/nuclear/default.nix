{ appimageTools, lib, fetchurl }:
let
  pname = "nuclear";
  version = "0.6.17";
  name = "${pname}-v${version}";

  src = fetchurl {
    url = "https://github.com/nukeop/nuclear/releases/download/v${version}/${name}.AppImage";
    sha256 = "M5nTsAUMItFDb1wd9mGDAnj+PgHMYMYiMtvtlc3GqVk=";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;
  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';
  extraPkgs = pkgs: with pkgs; [ wrapGAppsHook ];
  meta = with lib; {
    description = "Streaming music player that finds free music for you";
    homepage = "https://nuclear.js.org/";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
  };
}
