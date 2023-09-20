{ lib, fetchurl, appimageTools }:

let
  pname = "polypane";
  version = "14.1.0";

  src = fetchurl {
    url = "https://github.com/firstversionist/${pname}/releases/download/v${version}/${pname}-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    sha256 = "sha256-UJ4Ccz9PjpmZqJGbJjw3lyqR3VCl9xf3F6WUoBaUEVg=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname src version;
  };
in appimageTools.wrapType2 {
  inherit pname src version;

  multiArch = false;
  extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ pkgs.bash ];

  extraInstallCommands = ''
    ln -s $out/bin/${pname}-${version} $out/bin/${pname}
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
