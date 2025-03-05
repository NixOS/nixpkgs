{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  nix-update-script,
}:
let
  pname = "starc";
  version = "0.7.5";
  src = fetchurl {
    url = "https://github.com/story-apps/starc/releases/download/v${version}/starc-setup.AppImage";
    hash = "sha256-KAY04nXVyXnjKJxzh3Pvi50Vs0EPbLk0VgfZuz7MQR0=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  nativeBuildInputs = [ makeWrapper ];
  extraInstallCommands = ''
    # Fixup desktop item icons
    install -D ${appimageContents}/starc.desktop -t $out/share/applications/
    substituteInPlace $out/share/applications/starc.desktop \
      --replace-fail "Icon=starc" "${''
        Icon=dev.storyapps.starc
        StartupWMClass=Story Architect''}"
    cp -r ${appimageContents}/share/* $out/share/

    wrapProgram $out/bin/starc \
      --unset QT_PLUGIN_PATH
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Intuitive screenwriting app that streamlines the writing process";
    homepage = "https://starc.app/";
    mainProgram = "starc";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = [ "x86_64-linux" ];
  };
}
