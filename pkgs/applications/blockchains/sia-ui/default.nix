{ stdenv, fetchurl, makeDesktopItem, appimageTools, gtk3 }:

let
  pname = "sia-ui";
  version = "1.4.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://sia.tech/releases/Sia-UI-v${version}.AppImage";
    sha256 = "3ab7905f9075dd6a80953d1427bbc99ce1fc48f60d135bcfb136dcd267b11671";
  };

  xdg_dirs = builtins.concatStringsSep ":" [
    "${gtk3}/share/gsettings-schemas/${gtk3.name}"
  ];

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/sia-ui.desktop $out/share/applications/sia-ui.desktop
    install -m 444 -D ${appimageContents}/sia-ui.png $out/share/icons/hicolor/512x512/apps/sia-ui.png
    substituteInPlace $out/share/applications/sia-ui.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

   profile = ''
    export XDG_DATA_DIRS="${xdg_dirs}''${XDG_DATA_DIRS:+:"''$XDG_DATA_DIRS"}"
  '';

  meta = with stdenv.lib; {
    description = "A electron webapp to manage and interface with the Sia daemon";
    homepage = "https://sia.tech/";
    license = licenses.mit;
    maintainers = with maintainers; [ be7a ];
    platforms = [ "x86_64-linux" ];
  };
}
