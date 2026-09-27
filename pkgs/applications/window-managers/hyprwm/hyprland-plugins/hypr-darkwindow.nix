{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hypr-darkwindow";
  version = "0.56.2";

  src = fetchFromGitHub {
    owner = "micha4w";
    repo = "Hypr-DarkWindow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2upGTy7IRhrhxf+5VPjzrua8ebOtED6i8kSN8ka+ffg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv out/hypr-darkwindow.so $out/lib/libhypr-darkwindow.so

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland Plugin to invert Colors of specific Windows!";
    homepage = "https://github.com/micha4w/Hypr-DarkWindow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anninzy ];
    platforms = lib.platforms.linux;
  };
})
