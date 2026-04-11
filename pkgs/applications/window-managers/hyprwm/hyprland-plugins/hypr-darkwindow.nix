{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  nix-update-script,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hypr-darkwindow";
  version = "0.54.3";

  src = fetchFromGitHub {
    owner = "micha4w";
    repo = "Hypr-DarkWindow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nbaNBxREqiqc6bwUkgfyuCah61O89atJyNTPYq4Xij8=";
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
