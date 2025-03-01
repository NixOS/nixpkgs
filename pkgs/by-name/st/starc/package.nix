{
  stdenvNoCC,
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "starc";
  version = "0.7.5";

  src = fetchurl {
    url = "https://github.com/story-apps/starc/releases/download/v${finalAttrs.version}/starc-setup.AppImage";
    hash = "sha256-KAY04nXVyXnjKJxzh3Pvi50Vs0EPbLk0VgfZuz7MQR0=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      appimageContents = appimageTools.extract { inherit (finalAttrs) pname version src; };
      starc-unwrapped = appimageTools.wrapType2 { inherit (finalAttrs) pname version src; };
    in
    ''
      runHook preInstall

      # Fixup desktop item icons
      install -D ${appimageContents}/starc.desktop -t $out/share/applications/

      substituteInPlace $out/share/applications/starc.desktop \
      --replace-fail "Icon=starc" "${''
        Icon=dev.storyapps.starc
        StartupWMClass=Story Architect''}"

      cp -r ${appimageContents}/share/* $out/share/

      makeWrapper ${starc-unwrapped}/bin/starc $out/bin/starc \
        --unset QT_PLUGIN_PATH

      runHook postInstall
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
