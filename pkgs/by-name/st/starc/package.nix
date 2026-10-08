{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "starc";
  version = "0.8.2";

  src = fetchurl {
    url = "https://github.com/story-apps/starc/releases/download/v${finalAttrs.version}/starc-setup.AppImage";
    hash = "sha256-7uwc4gD+AlbYGMffaWj3v2Zt2x6P5edPXY3BsznBNdQ=";
  };

  nativeBuildInputs = [ makeWrapper ];
  extraInstallCommands = ''
    # Fixup desktop item icons
    install -D ${finalAttrs.contents}/starc.desktop -t $out/share/applications/
    substituteInPlace $out/share/applications/starc.desktop \
      --replace-fail "Icon=starc" "${''
        Icon=dev.storyapps.starc
        StartupWMClass=Story Architect''}"
    cp -r ${finalAttrs.contents}/share/* $out/share/

    wrapProgram $out/bin/starc \
      --unset QT_PLUGIN_PATH
  '';

  meta = {
    description = "Intuitive screenwriting app that streamlines the writing process";
    homepage = "https://starc.app/";
    mainProgram = "starc";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = [ "x86_64-linux" ];
  };
})
