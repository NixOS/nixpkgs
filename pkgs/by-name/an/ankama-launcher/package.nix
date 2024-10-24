{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "ankama-launcher";
  version = "3.12.17";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
    hash = "sha256-ssCjFrQYI/pxnsjcy1xLSpuGGy0NGMOcNP9RiNDhE/w=";
  };

  appimageContents = appimageTools.extract { inherit name src; };

in

appimageTools.wrapType2 {
  inherit name src;
  extraPkgs = pkgs: [ pkgs.wine ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/zaap.desktop $out/share/applications/ankama-launcher.desktop
    sed -i 's/.*Exec.*/Exec=ankama-launcher/' $out/share/applications/ankama-launcher.desktop
    install -m 444 -D ${appimageContents}/zaap.png $out/share/icons/hicolor/256x256/apps/zaap.png
  '';

  meta = {
    description = "Ankama Launcher";
    longDescription = ''
      Ankama Launcher is a portal that allows you to access Ankama's video games, VOD animations, webtoons, and livestreams, as well as download updates, stay up to date with the latest news, and chat with your friends.

      If you encounter a `wine` error while running *Dofus*, delete or rename the `cinematics/` directory:
      - Go to the directory where you installed the game and run: `mv content/gfx/cinematics content/gfx/cinematics_DISABLE`
    '';
    homepage = "https://www.ankama.com/en/launcher";
    license = lib.licenses.unfree;
    mainProgram = "ankama-launcher";
    maintainers = with lib.maintainers; [ harbiinger ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
