{ lib, fetchurl, appimageTools }:

let
  pname = "polypane";
  version = "19.0.2";

  src = fetchurl {
    url = "https://github.com/firstversionist/${pname}/releases/download/v${version}/${pname}-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    sha256 = "sha256-MyQiq2Lo/XtmJ7D1VZXncYWq53Bu3O3WBT/PkdJuEZM=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname src version;
  };
in appimageTools.wrapType2 {
  inherit pname src version;

  extraPkgs = pkgs: [ pkgs.bash ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
  '';

  meta = with lib; {
    description = "Browser with unified devtools targeting responsability and accessibility";
    longDescription = ''
      The stand-alone browser for ambitious developers that want to build responsive,
      accessible and performant websites in a fraction of the time it takes with other browsers.
    '';
    homepage = "https://polypane.app/";
    maintainers = with maintainers; [ zoedsoupe ];
    platforms = [ "x86_64-linux" ];
    changelog = "https://polypane.app/docs/changelog/";
    license = licenses.unfree;
  };
}
